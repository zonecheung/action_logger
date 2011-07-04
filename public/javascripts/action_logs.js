document.observe("dom:loaded", function() {
  $("action_logs_all").observe("click", function(event) {
    var status = $(event.element()).checked;

    $$("input[name='action_logs[]'][type=checkbox]").each(function(element) {
      $(element).checked = status;
    });
  });

  $$("a.delete-selected-link").each(function(element) {
    $(element).observe("click", function(event) {
      var target = $(event.element()),
          form   = target.up("form"),
          method = new Element("input", { type: "hidden", name: "_method", value: target.readAttribute("data-method") });

      event.stop();
      if ( window.confirm(target.readAttribute("data-confirm")) ) {
        form.writeAttribute("action", target.readAttribute("href"));
        form.insert(method);
        form.submit();
      }
    });  
  });

  var timeout = getTimeout();

  $("interval").observe("change", function(event) {
    window.clearTimeout(timeout);
    timeout = getTimeout();
  });

  function getTimeout() {
    var value = parseInt($("interval").value, 10);

    value = isNaN(value) ? 30 : value;
    $("interval").value = value;
    return window.setTimeout("$('action_logs_form').submit()", value * 1000);
  }
});

