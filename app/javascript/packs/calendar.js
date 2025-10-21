import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import listPlugin from "@fullcalendar/list";

document.addEventListener('turbolinks:load', function() {
  const calendarEls = document.getElementById('calendar');
  if (!calendarEls) return;
  const userId = calendarEls.dataset.userId;
  var calendar = new Calendar(calendarEls, {
    plugins: [dayGridPlugin, listPlugin],
    initialView: 'dayGridMonth',
    locale: "jp",
    events: `/users/${userId}/calendar_json`, 
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