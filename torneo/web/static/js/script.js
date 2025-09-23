document.getElementById("torneoForm").addEventListener("submit", e => {
  e.preventDefault();
  
  const config = {
    tripulaciones: [
      {
        nombre: "Sombrero de Paja",
        activo: e.target.sombrero.checked ? 1 : 0,
        personajes: [
          {nombre: "Luffy", activo: 1},
          {nombre: "Zoro", activo: 1},
          {nombre: "Sanji", activo: 1},
          {nombre: "Nami", activo: 1}
        ]
      },
      {
        nombre: "Barbanegra",
        activo: e.target.barbanegra.checked ? 1 : 0,
        personajes: [
          {nombre: "Teach", activo: 1},
          {nombre: "Burgess", activo: 1}
        ]
      },
      {
        nombre: "Bestias",
        activo: e.target.bestias?.checked ? 1 : 0,
        personajes: [
          {nombre: "Kaido", activo: 1},
          {nombre: "King", activo: 1}
        ]
      }
    ]
  };
  
  // Guardar configuración (simulado - en producción necesitarías un servidor)
  localStorage.setItem('torneo_config', JSON.stringify(config));
  
  // Mostrar feedback al usuario
  alert('✅ Configuración guardada! \n🚀 Ahora ejecuta: make demo');
  
  console.log('Configuración generada:', config);
});
