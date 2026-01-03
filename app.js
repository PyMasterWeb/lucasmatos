fetch("data/cursos.json")
  .then(res => res.json())
  .then(cursos => {
    const container = document.getElementById("cursos");

    cursos.forEach(curso => {
      container.innerHTML += `
        <div class="item">
          <h3>${curso.titulo}</h3>
          <p>${curso.descricao}</p>
          <a href="${curso.pdf}" download>Baixar PDF</a>
        </div>
      `;
    });
  });
