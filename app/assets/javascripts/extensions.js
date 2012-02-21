Object.extend(Ajax.InPlaceEditor.prototype, {
    onLoadedExternalText: function(transport) {
        Element.removeClassName(this.form,
            this.options.loadingClassName);
        this.editField.disabled = false;
        this.editField.value = transport.responseText;
        Field.scrollFreeActivate(this.editField);
    }

});

Object.extend(Ajax.InPlaceEditor.prototype, {
    getText: function() {
        return this.element.childNodes[0] ? this.element.childNodes
            [0].nodeValue : '';
    }

}); 