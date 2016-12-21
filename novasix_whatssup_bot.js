function sendMessage() {
    InputEvent = Event || InputEvent;
    var evt = new InputEvent('input', {
        bubbles: true
    });

    var input = document.querySelector("div.input");
    input.innerHTML = "[NOVA SIX BOT] - Olá pessoal! Setlist do ensaio de 7 Jan 17 \n - 1) Hazed Fog - Animal - https://youtu.be/mru1DHzuEaw,\n 2) Man in the Box - AIC - https://www.youtube.com/watch?v=TAqZb52sgpU,\n 3) Would - AIC - https://www.youtube.com/watch?v=Nco_kh8xJDs,\n 4) Angry Chair - AIC - https://www.youtube.com/watch?v=HJzrVtioigo,\n 5) Busca sem Fim - Nova Six - https://www.youtube.com/watch?v=727EZiNP0K8,\n 6) The Smashing Pumpkins - I Am One - https://youtu.be/Pi6RJmUNBbw,\n 7) Stone Temple Pilots - Dead and Bloated - https://youtu.be/OibNcmZcF3k,\n 8) Stone Temple Pilots - Plush - https://www.youtube.com/watch?v=V5UOC0C0x8Q";
    input.dispatchEvent(evt);

    document.querySelector(".btn-icon").click();
}

sendMessage()
