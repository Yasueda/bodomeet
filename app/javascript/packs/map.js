// ブートストラップ ローダ
(g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.${c}apis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})({
  key: process.env.Maps_API_Key
});

$(document).on('turbolinks:load', function () {
  async function initMap() {
    const mapEls = document.getElementById("map")
    if (!mapEls) return;
    const venue = mapEls.dataset.venue;
    const api_key = gon.geocodeing_api_key;

    const {Map} = await google.maps.importLibrary("maps");
    const {AdvancedMarkerElement} = await google.maps.importLibrary("marker");

    const res = await fetch(`https://maps.googleapis.com/maps/api/geocode/json?address=${venue}&key=${api_key}`);
    const data = await res.json();
    
    if (data.status === 'OK' && data.results[0]) {
      // Map取得
      const map = new Map(mapEls, {
        zoom: 15,
        center: data.results[0].geometry.location,
        mapId: "EVENT_MAP_ID",
        mapTypeControl: false
      });

      // Marker取得
      new AdvancedMarkerElement({
        position: data.results[0].geometry.location,
        map: map
      });
    } else {
      mapEls.textContent = "※場所情報からマップを取得できませんでした";
      $(mapEls).addClass('d-flex align-items-center justify-content-center text-danger bg-light');
    };
  }

  initMap();
});