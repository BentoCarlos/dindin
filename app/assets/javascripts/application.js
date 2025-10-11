import "jquery"; // Certifique-se que o jQuery é carregado
import "jquery-maskmoney"; // Importe a biblioteca que você instalou

document.addEventListener("DOMContentLoaded", function() {
  // Inicializa a máscara nos campos com a classe 'currency-input'
  $('.currency-input').maskMoney({
    prefix: 'R$ ',
    thousands: '.', // Ponto como separador de milhar
    decimal: ',',   // Vírgula como separador decimal
    allowZero: true,
    affixesStay: true
  });

  // Gatilho para iniciar a máscara nos elementos que já existem:
  $('.currency-input').trigger('mask.maskMoney'); 
});