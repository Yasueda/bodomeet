import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import listPlugin from "@fullcalendar/list";

document.addEventListener('turbolinks:load', function() {
  var calendarEl = document.getElementById('calendar');
  if (!calendarEl) return;
  const userId = calendarEl.dataset.userId;
  var calendar = new Calendar(calendarEl, {
    plugins: [dayGridPlugin, listPlugin],
    initialView: 'dayGridMonth',
    locale: "jp",
    events: `/users/${userId}/calender_json`, 
    windowResize: function () { 
        if (window.innerWidth < 991.98) {
            calendar.changeView('listMonth');
        } else {
            calendar.changeView('dayGridMonth');
        }
    },
  });
  calendar.render();
});