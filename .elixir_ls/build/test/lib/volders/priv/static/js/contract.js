function vendorChanged (vendor) {
  console.log(vendor)
  let elm = document.getElementById('select_category')
  if (vendor !== '') {
    elm.classList.add('is-visible')
    populate_category()
  } else {
    elm.classList.remove('is-visible')
  }
}

function populate_category () {
  let categorySelect = document.getElementById('contract_category')
  categorySelect.innerText = null
  let categories = []
  switch (document.getElementById('contract_vendor').value) {
    case 'Vodafone':
      categories = ['Internet', 'DSL', 'Phone', 'Mobile Phone']
      break;
    case 'O2':
      categories = ['Internet', 'DSL']
      break;
    case 'Vattenfall':
      categories = ['Internet', 'Electricity', 'Gas']
      break;
    default:
      categories = []
  }
  
  const options = categories.map(category => {
    categorySelect.add(new Option(category, category))
  })
}

function loadVendor() {
  if (document.getElementById("hidden_vendor")) {
  let selector = document.getElementById("hidden_vendor")
  document.getElementById("contract_vendor").value = selector.value
  vendorChanged(selector.value)
  selector = document.getElementById("hidden_category")
  document.getElementById("contract_category").value = selector.value
  }
}

