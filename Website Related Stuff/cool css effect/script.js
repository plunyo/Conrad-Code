const container = document.getElementById("tile-container");

const tileSize = 50;
const tilesAcross = Math.ceil(window.innerWidth / tileSize);
const tilesDown = Math.ceil(window.innerHeight / tileSize);

for (let i = 0; i < tilesAcross * tilesDown; i++) {
    const tile = document.createElement('div');
    tile.classList.add('tile');
    container.appendChild(tile);
}

const tiles = document.querySelectorAll('.tile');
tiles.forEach(tile => {
    tile.addEventListener('mouseover', function() {
        const r = Math.floor(Math.random() * 256);
        const g = Math.floor(Math.random() * 256);
        const b = Math.floor(Math.random() * 256);
      
        tile.style.backgroundColor = `rgb(${r}, ${g}, ${b})`;
    });

    tile.addEventListener('transitionend', function() {
        tile.style.backgroundColor = 'black';
    });
});
