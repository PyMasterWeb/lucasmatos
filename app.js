fetch("cursos.json")
  .then(res => res.json())
  .then(cursos => {
    const container = document.getElementById("cursos");

    cursos.forEach(curso => {
      container.innerHTML += `
        <div class="col-md-4 mb-3">
          <div class="card shadow-sm h-100">
            <div class="card-body">
              <h5>${curso.titulo}</h5>
              <p>${curso.descricao}</p>
              <a href="${curso.link}"
                 class="btn btn-primary w-100"
                 ${curso.download ? "download" : ""}>
                 Acessar
              </a>
            </div>
          </div>
        </div>
      `;
    });
  })
  .catch(err => console.error("Erro ao carregar cursos:", err));
