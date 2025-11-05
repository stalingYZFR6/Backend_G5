ALTER TABLE RegistroAsistencia
DROP FOREIGN KEY registroasistencia_ibfk_2;

ALTER TABLE RegistroAsistencia
ADD CONSTRAINT registroasistencia_ibfk_2
FOREIGN KEY (id_turno)
REFERENCES Turnos(id_turno)
ON DELETE CASCADE;