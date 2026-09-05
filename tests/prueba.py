from pathlib import Path
import clips

# Crear entorno CLIPS
env = clips.Environment()
archivo_clp = Path(__file__).parent.parent / "backend" / "conocimiento.clp"
# Cargar el archivo de reglas
env.load(str(archivo_clp))

# Crear solicitud
env.assert_string("""
(solicitud
   (tipo completo))
""")

# Crear ingredientes
env.assert_string("""
(ingrediente
   (nombre huevo)
   (categoria proteina))
""")

env.assert_string("""
(ingrediente
   (nombre cafe)
   (categoria bebida))
""")

env.assert_string("""
(ingrediente
   (nombre pan)
   (categoria carbohidrato))
""")

# Mostrar hechos antes de ejecutar
print("\n=== HECHOS INICIALES ===")
for fact in env.facts():
    print(fact)

# Mostrar agenda
print("\n=== AGENDA INICIAL ===")
print(env.eval("(agenda)"))

# Activar seguimiento de reglas
env.eval("(watch rules)")

# Ejecutar
print("\n=== EJECUTANDO ===")
env.run()

# Mostrar hechos finales
print("\n=== HECHOS FINALES ===")
for fact in env.facts():
    print(fact)