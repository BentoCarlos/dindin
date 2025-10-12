// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import { createConsumer } from "@rails/actioncable"

window.App ||= {}
try {
    window.App.cable ||= createConsumer() // cria a conexão WebSocket
    console.log("Action Cable consumer criado com sucesso!");
} catch (error) {
    console.error("Erro ao criar o Action Cable consumer:", error);
}
