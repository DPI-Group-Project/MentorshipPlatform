// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import dragula from "dragula";

import jquery from "jquery";
window.jQuery = jquery;
window.$ = jquery;
import Rails from "@rails/ujs";
Rails.start();

document.addEventListener("turbo:load", function () {
    console.log("Dragula initialized"); // Check if this runs
    
    const containers = [
      document.getElementById("mentor-list-section"),
      document.getElementById("short-list-card"),
    ];
  
    const drake = dragula(containers, {
      moves: function (el, container, handle) {
        return handle.classList.contains("handle");
      },
    });
  
    drake.on("drop", function (el, target, source, sibling) {
      console.log("Dropped:", el);
      console.log("New Parent:", target);
    });
  });