require 'spec_helper'

describe Eq2LogParser do
  fixtures :zones

  let(:file_name) { Rails.root.join('spec/fixtures/files/eq2log_Catharz.txt').to_s }
  let(:file) { File.open(file_name) }
  let(:character_list) {
    %w{
      Agaris Arcz Beodan Catharz Felixs Furiso Khalara Mitia
      Murdo Nakhari Porridge Purzz Radda Ryhino Spyce Totally Turgin
    }
  }

  context 'initialization' do
    it 'opens the file provided' do
      expect(File).to receive(:open).with(file_name)

      Eq2LogParser.new(file_name)
    end
  end

  context 'instance methods' do
    subject { Eq2LogParser.new(file_name) }

    describe '#parse' do
      it 'calls the methods to parse the data' do
        expect(subject).to receive(:parse_raids)
        expect(subject).to receive(:parse_zones)
        expect(subject).to receive(:populate_instances)

        subject.parse
      end
    end

    describe '#zone_entrances' do
      it 'searches the file for the zone entry points' do
        expect_any_instance_of(File).to receive(:grep).with(/You have entered/)

        subject.zone_entrances
      end
    end

    describe '#file_owner' do
      describe 'identifies the owner of files' do
        it 'without a date in the file name' do
          File.stub(:open).and_return(file)
          parser = Eq2LogParser.new('eq2log_Catharz.txt')
          expect(parser.file_owner).to eq 'Catharz'
        end

        it 'with a date in the file name' do
          File.stub(:open).and_return(file)
          parser = Eq2LogParser.new('eq2log_Menagerey.2012.05.27.txt')
          expect(parser.file_owner).to eq 'Menagerey'
        end

        it 'with a date and time in the file name' do
          File.stub(:open).and_return(file)
          parser = Eq2LogParser.new('eq2log_Fafhrd.2011.06.30.17.23.txt')
          expect(parser.file_owner).to eq 'Fafhrd'
        end
      end
    end

    describe '#real_name' do
      context 'returns the file own for' do
        example 'You' do
          subject.stub(:file_owner).and_return 'Fred'

          expect(subject.real_name('You')).to eq 'Fred'
        end

        example 'YOU' do
          subject.stub(:file_owner).and_return 'Barney'

          expect(subject.real_name('YOU')).to eq 'Barney'
        end

        example 'Your' do
          subject.stub(:file_owner).and_return 'Betty'

          expect(subject.real_name('Your')).to eq 'Betty'
        end

        example 'YOUR' do
          subject.stub(:file_owner).and_return 'Wilma'

          expect(subject.real_name('YOUR')).to eq 'Wilma'
        end
      end
    end

    describe '#zone_match' do
      let(:log_line) { "(1354411873)[Sun Dec 02 12:31:13 2012] You have entered Southern Cross' Guild Hall." }

      it 'extracts the log line id' do
        match = subject.zone_match(log_line)
        match.should_not be_nil
        expect(match['log_line_id']).to eq '1354411873'
      end

      it 'extracts the time the zone was entered' do
        match = subject.zone_match(log_line)
        match.should_not be_nil
        expect(match['log_date']).to eq 'Sun Dec 02 12:31:13 2012'
      end

      it 'extracts the zone name' do
        match = subject.zone_match(log_line)
        match.should_not be_nil
        expect(match['zone_name']).to eq "Southern Cross' Guild Hall"
      end
    end

    describe '#parse_raids' do
      it 'creates a key for each raid date' do
        zone_entrances = ["(1354411873)[Sun Dec 02 12:31:13 2012] You have entered Plane of War.",
                          "(1354411873)[Mon Dec 03 12:31:13 2012] You have entered Southern Cross' Guild Hall."]
        subject.stub(:zone_entrances).and_return(zone_entrances)

        expect(subject.parse_raids.keys).to eq [Date.parse('Sun Dec 02 2012'), Date.parse('Mon Dec 03 2012')]
      end

      it 'creates an empty instances array for each raid' do
        zone_entrances = ["(1354411873)[Sun Dec 02 12:31:13 2012] You have entered Plane of War.",
                          "(1354411873)[Mon Dec 03 12:31:13 2012] You have entered Southern Cross' Guild Hall."]
        subject.stub(:zone_entrances).and_return(zone_entrances)

        expect(subject.parse_raids[Date.parse('Sun Dec 02 2012')][:instances]).to eq []
      end
    end

    describe '#parse_zones' do
      it 'obtains the raid date' do
        zone_entrances = ["(1354411873)[Sun Dec 02 18:31:13 2012] You have entered Plane of War.",
                          "(1354411900)[Sun Dec 02 20:31:13 2012] You have entered Southern Cross' Guild Hall."]
        subject.stub(:zone_entrances).and_return(zone_entrances)

        subject.parse_raids
        subject.parse_zones

        instance_list = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances]
        expect(instance_list.first[:raid_date]).to eq Date.parse('Sun Dec 02 2012')
      end

      it 'obtains the name of each zone' do
        zone_entrances = ["(1354411873)[Sun Dec 02 12:31:13 2012] You have entered Plane of War.",
                          "(1354411900)[Sun Dec 02 12:31:13 2012] You have entered Southern Cross' Guild Hall."]
        subject.stub(:zone_entrances).and_return(zone_entrances)

        subject.parse_raids
        subject.parse_zones

        instance_list = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances]
        expect(instance_list.first[:zone_name]).to eq "Plane of War"
      end

      it 'obtains the log start line' do
        zone_entrances = ["(1354411873)[Sun Dec 02 18:31:13 2012] You have entered Plane of War.",
                          "(1354411999)[Sun Dec 02 20:31:13 2012] You have entered Southern Cross' Guild Hall."]
        subject.stub(:zone_entrances).and_return(zone_entrances)

        subject.parse_raids
        subject.parse_zones

        instance_list = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances]
        expect(instance_list.first[:start_line]).to eq 1354411873
        expect(instance_list.first[:end_line]).to eq 1354411999
      end

      it 'obtains the log end line' do
        zone_entrances = ["(1354411873)[Sun Dec 02 18:31:13 2012] You have entered Plane of War.",
                          "(1354411999)[Sun Dec 02 20:31:13 2012] You have entered Southern Cross' Guild Hall."]
        subject.stub(:zone_entrances).and_return(zone_entrances)

        subject.parse_raids
        subject.parse_zones

        instance_list = subject.raid_list[Date.parse('Sun dec 02 2012')][:instances]
        expect(instance_list.first[:end_line]).to eq 1354411999
      end

      it 'obtains the zone entry time' do
        zone_entrances = ["(1354411873)[Sun Dec 02 19:31:13 2012] You have entered Plane of War.",
                          "(1354411873)[Sun Dec 02 20:31:13 2012] You have entered Southern Cross' Guild Hall."]
        subject.stub(:zone_entrances).and_return(zone_entrances)

        subject.parse_raids
        subject.parse_zones

        instance_list = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances]
        expect(instance_list.first[:entry_time]).to eq Time.zone.parse('Sun Dec 02 19:31:13 2012')
      end

      it 'obtains the zone exit time' do
        zone_entrances = ["(1354411873)[Sun Dec 02 18:31:13 2012] You have entered Plane of War.",
                          "(1354411873)[Sun Dec 02 20:31:13 2012] You have entered Southern Cross' Guild Hall."]
        subject.stub(:zone_entrances).and_return(zone_entrances)

        subject.parse_raids
        subject.parse_zones

        instance_list = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances]
        expect(instance_list.first[:exit_time]).to eq Time.zone.parse('Sun Dec 02 20:31:13 2012')
      end

      it 'defaults the end time to midnight' do
        zone_entrances = ["(1354411873)[Sat Sep 17 18:31:13 2011] You have entered Plane of War."]
        subject.stub(:zone_entrances).and_return(zone_entrances)

        subject.parse_raids
        subject.parse_zones

        instance_list = subject.raid_list[Date.parse('Sat Sep 17 2011')][:instances]
        expect(instance_list.first[:exit_time]).to eq Time.zone.parse('Sat Sep 17 00:00:00 2011')
      end

      it 'cleans up trailing instances' do
        File.stub(:open).and_return StringIO.new %q{
          (1354411800)[Sat Sep 17 20:00:00 2011] You have entered Plane of War.
          (1354411820)[Sat Sep 17 20:11:38 2011] Mitia's Hemotoxin hits Prime-Cornicen Munderrad for 1115 poison damage.
          (1354411840)[Sat Sep 17 20:11:39 2011] Beodan's Rime Strike hits Prime-Cornicen Munderrad for 1791 heat damage.
          (1354411850)[Sat Sep 17 20:11:39 2011] Flecks hits Prime-Cornicen Munderrad for 50447 crushing damage.
          (1354411860)[Sat Sep 17 20:11:39 2011] YOU hit Prime-Cornicen Munderrad for 5447 crushing damage.
          (1354411900)[Sat Sep 17 20:30:00 2011] You have entered Southern Cross' Guild Hall.
         }
        %w{Mitia Beodan Catharz Flecks}.each do |character|
          FactoryGirl.create(:character, name: character)
        end

        subject.parse

        instance_list = subject.raid_list[Date.parse('Sat Sep 17 2011')][:instances]
        expect(instance_list.size).to eq 1
      end

      it 'only counts known raid zones' do
        File.stub(:open).and_return StringIO.new %q{
          (1354411800)[Sat Sep 17 20:00:00 2011] You have entered Plane of War.
          (1354411820)[Sat Sep 17 20:11:38 2011] Mitia's Hemotoxin hits Prime-Cornicen Munderrad for 1115 poison damage.
          (1354411840)[Sat Sep 17 20:11:39 2011] Beodan's Rime Strike hits Prime-Cornicen Munderrad for 1791 heat damage.
          (1354411850)[Sat Sep 17 20:11:39 2011] Flecks hits Prime-Cornicen Munderrad for 50447 crushing damage.
          (1354411860)[Sat Sep 17 20:11:39 2011] YOU hit Prime-Cornicen Munderrad for 5447 crushing damage.
          (1354411900)[Sat Sep 17 20:30:00 2011] You have entered Southern Cross' Guild Hall.
          (1354412800)[Sat Sep 17 21:00:00 2011] You have entered Nowhere Special.
          (1354412820)[Sat Sep 17 21:11:38 2011] Mitia's Hemotoxin hits Prime-Cornicen Munderrad for 1115 poison damage.
          (1354412840)[Sat Sep 17 21:11:39 2011] Beodan's Rime Strike hits Prime-Cornicen Munderrad for 1791 heat damage.
          (1354412850)[Sat Sep 17 21:11:39 2011] Flecks hits Prime-Cornicen Munderrad for 50447 crushing damage.
          (1354412860)[Sat Sep 17 21:11:39 2011] YOU hit Prime-Cornicen Munderrad for 5447 crushing damage.
          (1354412900)[Sat Sep 17 21:30:00 2011] You have entered Southern Cross' Guild Hall.
         }
        %w{Mitia Beodan Catharz Flecks}.each do |character|
          FactoryGirl.create(:character, name: character)
        end

        subject.parse

        instance_list = subject.raid_list[Date.parse('Sat Sep 17 2011')][:instances]
        expect(instance_list.size).to eq 1
      end

      it 'cleans up empty raids' do
        File.stub(:open).and_return StringIO.new %q{
          (1354411800)[Sat Sep 17 20:00:00 2011] You have entered The Twilight Zone.
          (1354411820)[Sat Sep 17 20:11:38 2011] Mitia's Hemotoxin hits Prime-Cornicen Munderrad for 1115 poison damage.
          (1354411840)[Sat Sep 17 20:11:39 2011] Beodan's Rime Strike hits Prime-Cornicen Munderrad for 1791 heat damage.
          (1354411850)[Sat Sep 17 20:11:39 2011] Flecks hits Prime-Cornicen Munderrad for 50447 crushing damage.
          (1354411860)[Sat Sep 17 20:11:39 2011] YOU hit Prime-Cornicen Munderrad for 5447 crushing damage.
          (1354411900)[Sat Sep 17 20:30:00 2011] You have entered Southern Cross' Guild Hall.
          (1354412800)[Sat Sep 17 21:00:00 2011] You have entered Nowhere Special.
          (1354412820)[Sat Sep 17 21:11:38 2011] Mitia's Hemotoxin hits Prime-Cornicen Munderrad for 1115 poison damage.
          (1354412840)[Sat Sep 17 21:11:39 2011] Beodan's Rime Strike hits Prime-Cornicen Munderrad for 1791 heat damage.
          (1354412850)[Sat Sep 17 21:11:39 2011] Flecks hits Prime-Cornicen Munderrad for 50447 crushing damage.
          (1354412860)[Sat Sep 17 21:11:39 2011] YOU hit Prime-Cornicen Munderrad for 5447 crushing damage.
          (1354412900)[Sat Sep 17 21:30:00 2011] You have entered Southern Cross' Guild Hall.
         }
        %w{Mitia Beodan Catharz Flecks}.each do |character|
          FactoryGirl.create(:character, name: character)
        end

        subject.parse

        expect(subject.raid_list).to be_empty
      end

      it 'cleans up instances with less than 2 attendees' do
        File.stub(:open).and_return StringIO.new %q{
          (1354411800)[Sat Sep 17 20:00:00 2011] You have entered Plane of War.
          (1354411820)[Sat Sep 17 20:11:38 2011] Mitia's Hemotoxin hits Prime-Cornicen Munderrad for 1115 poison damage.
          (1354411840)[Sat Sep 17 20:11:39 2011] Beodan's Rime Strike hits Prime-Cornicen Munderrad for 1791 heat damage.
          (1354411850)[Sat Sep 17 20:11:39 2011] Flecks hits Prime-Cornicen Munderrad for 50447 crushing damage.
          (1354411860)[Sat Sep 17 20:11:39 2011] YOU hit Prime-Cornicen Munderrad for 5447 crushing damage.
          (1354411900)[Sat Sep 17 20:30:00 2011] You have entered Southern Cross' Guild Hall.
          (1354411950)[Sat Sep 17 21:00:00 2011] You have entered Dracur Prime: Sevalak Awakened.
          (1354411960)[Sat Sep 17 21:15:15 2011] Barney hits Prime-Cornicen Munderrad for 40440 crushing damage.
          (1354411970)[Sat Sep 17 21:30:30 2011] YOU hit Prime-Cornicen Munderrad for 5447 crushing damage.
          (1354411980)[Sat Sep 17 22:00:00 2011] You have entered Southern Cross' Guild Hall.
         }
        %w{Mitia Beodan Catharz Flecks}.each do |character|
          FactoryGirl.create(:character, name: character)
        end

        subject.parse

        instance_list = subject.raid_list[Date.parse('Sat Sep 17 2011')][:instances]
        expect(instance_list.count).to eq 1
      end
    end

    describe '#populate_instances' do
      it 'iterates through the raid list' do
        expect(subject.raid_list).to receive(:each_pair)
        subject.populate_instances
      end

      context 'populates drops' do
        context 'with attributes' do
          let(:log_file) {
            StringIO.new %q{
              (1354411800)[Sun Dec 02 20:12:30 2012] You have entered Plane of War.
              (1354411820)[Sun Dec 02 20:11:30 2012] Spyce's Amnesia hits Prime-Cornicen Munderrad for 1115 magic damage.
              (1354411840)[Sun Dec 02 20:12:30 2012] Chiteira's Rime Strike hits Prime-Cornicen Munderrad for 1791 heat damage.
              (1354411860)[Sun Dec 02 20:13:30 2012] YOU hit Prime-Cornicen Munderrad for 5447 crushing damage.
              (1354411870)[Sun Dec 02 20:14:30 2012] You loot \aITEM 842968069 -1475883379:Pure Primal Velium Shard\/a from the Exquisite Chest of Prime-Cornicen Munderrad1.
              (1354411880)[Sun Dec 02 20:14:34 2012] Chiteira loots \aITEM 1371925287 183231148:Thornskin VIII (Master)\/a from the Exquisite Chest of Prime-Cornicen Munderrad2.
              (1354411890)[Sun Dec 02 20:15:35 2012] Spyce loots \aITEM 595219945 -1154546896:Wand of the Kromzek Warmonger\/a from the Exquisite Chest of Prime-Cornicen Munderrad3.
              (1354411900)[Sun Dec 02 20:16:30 2012] You have entered Southern Cross' Guild Hall.
            }
          }
          example 'item name' do
            File.stub(:open).and_return log_file
            %w{Catharz Chiteira Spyce}.each do |character|
              FactoryGirl.create(:character, name: character)
            end

            subject.parse

            first_instance = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances].first
            last_drop = first_instance[:drops].last
            expect(last_drop[:item_name]).to eq 'Wand of the Kromzek Warmonger'
          end

          example 'item id' do
            File.stub(:open).and_return log_file
            %w{Catharz Chiteira Spyce}.each do |character|
              FactoryGirl.create(:character, name: character)
            end

            subject.parse

            first_instance = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances].first
            drop = first_instance[:drops][1]
            expect(drop[:item_id]).to eq '1371925287'
          end

          example 'looter name' do
            File.stub(:open).and_return log_file
            %w{Catharz Chiteira Spyce}.each do |character|
              FactoryGirl.create(:character, name: character)
            end

            subject.parse

            first_instance = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances].first
            last_drop = first_instance[:drops].last
            expect(last_drop[:looter]).to eq 'Spyce'
          end

          example 'drop time' do
            File.stub(:open).and_return log_file
            %w{Catharz Chiteira Spyce}.each do |character|
              FactoryGirl.create(:character, name: character)
            end

            subject.parse

            first_instance = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances].first
            first_drop = first_instance[:drops].first
            expect(first_drop[:log_date]).to eq 'Sun Dec 02 20:14:30 2012'
          end

          example 'mob name' do
            File.stub(:open).and_return log_file
            %w{Catharz Chiteira Spyce}.each do |character|
              FactoryGirl.create(:character, name: character)
            end

            subject.parse

            first_instance = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances].first
            drop = first_instance[:drops][1]
            expect(drop[:mob_name]).to eq 'Prime-Cornicen Munderrad2'
          end
        end
      end

      context 'populates attendees' do
        example 'excluding unknown characters' do
          File.stub(:open).and_return StringIO.new %q{
           (1354411800)[Sat Sep 17 20:00:00 2011] You have entered Plane of War.
           (1354411820)[Sat Sep 17 20:11:38 2011] Mitia's Hemotoxin hits Prime-Cornicen Munderrad for 1115 poison damage.
           (1354411840)[Sat Sep 17 20:11:39 2011] Beodan's Rime Strike hits Prime-Cornicen Munderrad for 1791 heat damage.
           (1354411850)[Sat Sep 17 20:11:39 2011] Barney hits YOU for 50447 crushing damage.
           (1354411860)[Sat Sep 17 20:11:39 2011] YOU hit Prime-Cornicen Munderrad for 5447 crushing damage.
           (1354411900)[Sat Sep 17 22:30:00 2011] You have entered Southern Cross' Guild Hall.
         }
          %w{Mitia Beodan Catharz}.each do |character|
            FactoryGirl.create(:character, name: character)
          end

          subject.parse_raids
          subject.parse_zones
          subject.populate_instances

          first_instance = subject.raid_list[Date.parse('Sat Sep 17 2011')][:instances].first
          expect(first_instance[:attendees]).to match_array %w{Mitia Beodan Catharz}
        end

        context 'identified by' do
          example 'talking in raid chat' do
            File.stub(:open).and_return StringIO.new %q{
              (1354411800)[Sun Dec 02 20:00:00 2012] You have entered Plane of War.
              (1354411801)[Sat Dec 02 20:14:56 2012] \aPC -1 Spyce:Spyce\/a says to the raid party, "need"
              (1354411850)[Sat Dec 02 20:15:03 2012] \aPC -1 Murdo:Murdo\/a says to the raid party, "need"
              (1354411899)[Sat Dec 02 20:15:05 2012] \aPC -1 Arcz:Arcz\/a says to the raid party, "COB Raid Wide~ Increasing Attack Speed"
              (1354411900)[Sun Dec 02 22:30:00 2012] You have entered Southern Cross' Guild Hall.
            }
            subject.stub(:character_names).and_return %w{Furiso Catharz Ryhino Nakhari Purzz Turgin Spyce Murdo Arcz Porridge Agaris Khalara}

            subject.parse_raids
            subject.parse_zones
            subject.populate_instances

            first_instance = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances].first
            expect(first_instance[:attendees]).to match_array %w{Spyce Murdo Arcz}
          end

          example 'healing and being healed' do
            File.stub(:open).and_return StringIO.new %q{
              (1354411800)[Sun Dec 02 20:00:00 2012] You have entered Plane of War.
              (1354411825)[Sun Dec 02 20:01:00 2012] Nakhari's Combat Glory critically heals YOU for 530 hit points.
              (1354411850)[Sun Dec 02 20:02:00 2012] Purzz's Autumn's Kiss critically heals Ryhino for 1178 hit points.
              (1354411875)[Sun Dec 02 20:03:00 2012] Turgin's Divine Armor heals Furiso for 1583 hit points.
              (1354411900)[Sun Dec 02 22:30:00 2012] You have entered Southern Cross' Guild Hall.
            }
            subject.stub(:character_names).and_return %w{Furiso Catharz Ryhino Nakhari Purzz Turgin Spyce Murdo Arcz Porridge Agaris Khalara}

            subject.parse_raids
            subject.parse_zones
            subject.populate_instances

            first_instance = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances].first
            expect(first_instance[:attendees]).to match_array %w{Furiso Catharz Ryhino Nakhari Purzz Turgin}
          end

          context 'hitting mobs with' do
            example 'normal hits' do
              File.stub(:open).and_return StringIO.new %q{
               (1354411800)[Sat Sep 17 20:00:00 2011] You have entered Plane of War.
               (1354411820)[Sat Sep 17 20:11:38 2011] Mitia's Hemotoxin hits Prime-Cornicen Munderrad for 1115 poison damage.
               (1354411840)[Sat Sep 17 20:11:39 2011] Beodan's Rime Strike hits Prime-Cornicen Munderrad for 1791 heat damage.
               (1354411850)[Sat Sep 17 20:11:39 2011] YOU hit Prime-Cornicen Munderrad for 5447 crushing damage.
               (1354411900)[Sat Sep 17 22:30:00 2011] You have entered Southern Cross' Guild Hall.
             }
              subject.stub(:character_names).and_return character_list

              subject.parse_raids
              subject.parse_zones
              subject.populate_instances

              first_instance = subject.raid_list[Date.parse('Sat Sep 17 2011')][:instances].first
              expect(first_instance[:attendees]).to match_array %w{Mitia Beodan Catharz}
            end

            example 'critical hits' do
              File.stub(:open).and_return StringIO.new %q{
                (1354411800)[Sat Sep 17 20:00:00 2011] You have entered Plane of War.
                (1354411810)[Sat Sep 17 20:11:38 2011] Porridge's Blade Chime critically hits Prime-Cornicen Munderrad for 4247 disease damage.
                (1354411830)[Sat Sep 17 20:11:39 2011] Agaris' Precise Note critically hits Prime-Cornicen Munderrad for 11207 mental damage.
                (1354411850)[Sat Sep 17 20:11:44 2011] YOU critically hit Prime-Cornicen Munderrad for 35538 crushing damage.
                (1354411900)[Sat Sep 17 22:30:00 2011] You have entered Southern Cross' Guild Hall.
              }
              subject.stub(:character_names).and_return character_list

              subject.parse_raids
              subject.parse_zones
              subject.populate_instances

              first_instance = subject.raid_list[Date.parse('Sat Sep 17 2011')][:instances].first
              expect(first_instance[:attendees]).to match_array %w{Porridge Agaris Catharz}
            end

            example 'multi attacks' do
              File.stub(:open).and_return StringIO.new %q{
                (1354411800)[Sat Sep 17 20:00:00 2011] You have entered Plane of War.
                (1354411810)[Sat Sep 17 20:11:39 2011] YOU multi attack Prime-Cornicen Munderrad for 9921 crushing damage.
                (1354411830)[Sat Sep 17 20:11:44 2011] Porridge critically multi attacks Prime-Cornicen Munderrad for 7737 piercing damage.
                (1354411850)[Sat Sep 17 20:11:44 2011] Purzz's Death Swarm critically multi attacks Prime-Cornicen Munderrad for 10164 divine damage.
                (1354411870)[Sat Sep 17 20:11:44 2011] Felixs critically multi attacks Prime-Cornicen Munderrad for 12761 slashing damage.
                (1354411900)[Sat Sep 17 22:30:00 2011] You have entered Southern Cross' Guild Hall.
              }
              subject.stub(:character_names).and_return character_list

              subject.parse_raids
              subject.parse_zones
              subject.populate_instances

              first_instance = subject.raid_list[Date.parse('Sat Sep 17 2011')][:instances].first
              expect(first_instance[:attendees]).to match_array %w{Catharz Porridge Purzz Felixs}
            end

          end

          context 'being hit by' do
            example 'normal hits' do
              File.stub(:open).and_return StringIO.new %q{
                (1354411800)[Sun Dec 02 20:00:00 2012] You have entered Plane of War.
                (1354411820)[Sun Dec 02 20:00:00 2012] Idol of Rallos Zek hits YOU for 1000 crushing damage.
                (1354411840)[Sun Dec 02 20:00:00 2012] a temple secutor's Whirling Attack hits Turgin for 7616 crushing damage.
                (1354411860)[Sun Dec 02 20:00:00 2012] Idol of Rallos Zek's Unavoidable Annihilation hits Khalara for 5743 crushing damage.
                (1354411900)[Sun Dec 02 22:30:00 2012] You have entered Southern Cross' Guild Hall.
              }
              subject.stub(:character_names).and_return character_list

              subject.parse_raids
              subject.parse_zones
              subject.populate_instances

              first_instance = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances].first
              expect(first_instance[:attendees]).to match_array %w{Catharz Turgin Khalara}
            end

            example 'critical hits' do
              File.stub(:open).and_return StringIO.new %q{
                (1354411800)[Sun Dec 02 20:00:00 2012] You have entered Plane of War.
                (1354411820)[Sun Dec 02 20:00:00 2012] Idol of Rallos Zek critically hits YOU for 1000 crushing damage.
                (1354411840)[Sun Dec 02 20:00:00 2012] a temple secutor's Whirling Attack critically hits Turgin for 7616 crushing damage.
                (1354411860)[Sun Dec 02 20:00:00 2012] Idol of Rallos Zek's Unavoidable Annihilation critically hits Khalara for 5743 crushing damage.
                (1354411900)[Sun Dec 02 22:30:00 2012] You have entered Southern Cross' Guild Hall.
              }
              subject.stub(:character_names).and_return character_list

              subject.parse_raids
              subject.parse_zones
              subject.populate_instances

              first_instance = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances].first
              expect(first_instance[:attendees]).to match_array %w{Catharz Turgin Khalara}
            end

            example 'multi attacks' do
              File.stub(:open).and_return StringIO.new %q{
                (1354411800)[Sun Dec 02 20:00:00 2012] You have entered Plane of War.
                (1354411820)[Sun Dec 02 20:00:00 2012] Idol of Rallos Zek multi attacks YOU for 31905 crushing damage.
                (1354411840)[Sun Dec 02 20:00:00 2012] a Half-Drained Corpse multi attacks Radda for 8328 crushing damage.
                (1354411860)[Sun Dec 02 20:00:00 2012] a Kromzek praepost critically multi attacks Furiso for 25793 crushing damage.
                (1354411900)[Sun Dec 02 22:30:00 2012] You have entered Southern Cross' Guild Hall.
              }
              subject.stub(:character_names).and_return character_list

              subject.parse_raids
              subject.parse_zones
              subject.populate_instances

              first_instance = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances].first
              expect(first_instance[:attendees]).to match_array %w{Catharz Radda Furiso}
            end

            example 'big fat nothing' do
              File.stub(:open).and_return StringIO.new %q{
                (1354411800)[Sun Dec 02 20:00:00 2012] You have entered Plane of War.
                (1354411810)[Sun Dec 02 20:10:00 2012] kromzek stormtrooper tries to crush Furiso, but misses.
                (1354411820)[Sun Dec 02 20:20:00 2012] a Kromzek praepost tries to crush YOU, but YOU parry.
                (1354411830)[Sun Dec 02 20:30:00 2012] a misty crusader tries to crush Totally, but Totally ripostes.
                (1354411840)[Sun Dec 02 20:40:00 2012] Primus Pilus Gunnr tries to crush Radda, but Radda dodges the multi attack.
                (1354411850)[Sun Dec 02 20:50:00 2012] a Kromzek patratus hits Agaris but fails to inflict any damage.
                (1354411860)[Sun Dec 02 21:00:00 2012] Enraged Flame of War tries to freeze Purzz with Suffocating Winds, but Purzz resists.
                (1354411870)[Sun Dec 02 21:00:00 2012] Supreme Imperium Valdemar multi attacks Murdo but fails to inflict any damage.
                (1354411900)[Sun Dec 02 22:30:00 2012] You have entered Southern Cross' Guild Hall.
              }
              subject.stub(:character_names).and_return character_list

              subject.parse_raids
              subject.parse_zones
              subject.populate_instances

              first_instance = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances].first
              expect(first_instance[:attendees]).to match_array %w{Catharz Radda Furiso Totally Agaris Murdo Purzz}
            end
          end
        end
      end
    end

    describe 'data retrieved from drops' do
      let(:file_data) {
        StringIO.new %q{
          (1354411800)[Sun Dec 02 20:00:00 2012] You have entered Plane of War.
          (1354411810)[Sun Dec 02 20:10:00 2012] kromzek stormtrooper tries to crush Furiso, but misses.
          (1354411820)[Sun Dec 02 20:20:00 2012] a Kromzek praepost tries to crush YOU, but YOU parry.
          (1354411830)[Sun Dec 02 20:30:00 2012] a misty crusader tries to crush Totally, but Totally ripostes.
          (1354411840)[Sun Dec 02 20:40:00 2012] Primus Pilus Gunnr tries to crush Radda, but Radda dodges the multi attack.
          (1354411842)[Sun Dec 02 20:43:01 2012] Random: Coronary rolls from 1 to 100 on the magic dice...and scores a 2!
          (1354411842)[Sun Dec 02 20:43:02 2012] \aPC -1 Ryhino:Ryhino\/a says to the guild, "lamo"
          (1354411842)[Sun Dec 02 20:43:03 2012] \aPC -1 Beodan:Beodan\/a says to the officers, "Its Ryhinos Fault!!!"
          (1354411842)[Sun Dec 02 20:43:04 2012] \aPC -1 Agaris:Agaris\/a says to the raid party, "Grats! :)"
          (1354411842)[Sun Dec 02 20:43:04 2012] You loot \aITEM 842968069 -1475883379:Pure Primal Velium Shard\/a from the Exquisite Chest of Prime-Cornicen Munderrad1.
          (1354411842)[Sun Dec 02 20:43:05 2012] You loot \aITEM 1371925287 183231148:Thornskin VIII (Master)\/a from the Exquisite Chest of Prime-Cornicen Munderrad2.
          (1354411842)[Sun Dec 02 20:43:06 2012] Spyce loots \aITEM 595219945 -1154546896:Wand of the Kromzek Warmonger\/a from the Exquisite Chest of Prime-Cornicen Munderrad3.
          (1354411850)[Sun Dec 02 20:50:00 2012] a Kromzek patratus hits Agaris but fails to inflict any damage.
          (1354411860)[Sun Dec 02 21:00:00 2012] Enraged Flame of War tries to freeze Purzz with Suffocating Winds, but Purzz resists.
          (1354411870)[Sun Dec 02 21:00:00 2012] Supreme Imperium Valdemar multi attacks Murdo but fails to inflict any damage.
          (1354411900)[Sun Dec 02 22:30:00 2012] You have entered Southern Cross' Guild Hall.
        }
      }

      context '#drops' do
        context 'includes drops' do
          it 'from the start of the log section' do
            File.stub(:open).and_return file_data
            subject.stub(:character_names).and_return character_list

            subject.parse_raids
            subject.parse_zones
            subject.populate_instances

            expect(subject.drops(1354411800, 1354411900).collect { |d| d[:item_name]}).to include 'Pure Primal Velium Shard'
          end

          it 'from the end of the log section' do
            File.stub(:open).and_return file_data
            subject.stub(:character_names).and_return character_list

            subject.parse_raids
            subject.parse_zones
            subject.populate_instances

            expect(subject.drops(1354411800, 1354411900).collect { |d| d[:item_name]}).to include 'Wand of the Kromzek Warmonger'
          end

          it 'from the middle of the log section' do
            File.stub(:open).and_return file_data
            subject.stub(:character_names).and_return character_list

            subject.parse_raids
            subject.parse_zones
            subject.populate_instances
            drop_list = ['Pure Primal Velium Shard', 'Thornskin VIII (Master)', 'Wand of the Kromzek Warmonger']

            expect(subject.drops(1354411800, 1354411900).collect { |d| d[:item_name]}).to match_array drop_list
          end
        end
      end

      context '#prior_chat' do
        context 'includes preceeding chat' do
          example 'from raid chat' do
              File.stub(:open).and_return file_data
              subject.stub(:character_names).and_return character_list

              subject.parse_raids
              subject.parse_zones
              subject.populate_instances

              instance_list = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances]
              drop_list = instance_list.first[:drops]
              last_drop = drop_list.last
              expect(subject.prior_chat Time.zone.parse(last_drop[:log_date])).to include '(1354411842)[Sun Dec 02 20:43:04 2012] \aPC -1 Agaris:Agaris\/a says to the raid party, "Grats! :)"'
          end

          example 'from guild chat' do
              File.stub(:open).and_return file_data
              subject.stub(:character_names).and_return character_list

              subject.parse_raids
              subject.parse_zones
              subject.populate_instances

              instance_list = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances]
              drop_list = instance_list.first[:drops]
              last_drop = drop_list.last
              expect(subject.prior_chat Time.zone.parse(last_drop[:log_date])).to include '(1354411842)[Sun Dec 02 20:43:02 2012] \aPC -1 Ryhino:Ryhino\/a says to the guild, "lamo"'
          end

          example 'from officer chat' do
              File.stub(:open).and_return file_data
              subject.stub(:character_names).and_return character_list

              subject.parse_raids
              subject.parse_zones
              subject.populate_instances

              instance_list = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances]
              drop_list = instance_list.first[:drops]
              last_drop = drop_list.last
              expect(subject.prior_chat Time.zone.parse(last_drop[:log_date])).to include '(1354411842)[Sun Dec 02 20:43:03 2012] \aPC -1 Beodan:Beodan\/a says to the officers, "Its Ryhinos Fault!!!"'
          end

          example 'from /random rolls' do
              File.stub(:open).and_return file_data
              subject.stub(:character_names).and_return character_list

              subject.parse_raids
              subject.parse_zones
              subject.populate_instances

              instance_list = subject.raid_list[Date.parse('Sun Dec 02 2012')][:instances]
              drop_list = instance_list.first[:drops]
              last_drop = drop_list.last
              expect(subject.prior_chat Time.zone.parse(last_drop[:log_date])).to include '(1354411842)[Sun Dec 02 20:43:01 2012] Random: Coronary rolls from 1 to 100 on the magic dice...and scores a 2!'
          end
        end
      end

      context '#mobs' do
        context 'includes mobs' do
          it 'from the start of the log section' do
            File.stub(:open).and_return file_data
            subject.stub(:character_names).and_return character_list

            subject.parse_raids
            subject.parse_zones
            subject.populate_instances

            expect(subject.mobs(1354411800, 1354411900)).to include 'Prime-Cornicen Munderrad1'
          end

          it 'from the end of the log section' do
            File.stub(:open).and_return file_data
            subject.stub(:character_names).and_return character_list

            subject.parse_raids
            subject.parse_zones
            subject.populate_instances

            expect(subject.mobs(1354411800, 1354411900)).to include 'Prime-Cornicen Munderrad3'
          end

          it 'from the middle of the log section' do
            File.stub(:open).and_return file_data
            subject.stub(:character_names).and_return character_list

            subject.parse_raids
            subject.parse_zones
            subject.populate_instances
            mob_list =['Prime-Cornicen Munderrad1', 'Prime-Cornicen Munderrad2', 'Prime-Cornicen Munderrad3']

            expect(subject.mobs(1354411800, 1354411900)).to match_array mob_list
          end
        end
      end
    end
  end
end
