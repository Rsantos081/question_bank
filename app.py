from flask import Flask, render_template, request, redirect, session
import mysql.connector
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)

app.secret_key = os.getenv("SECRET_KEY")
conexao = mysql.connector.connect(
    host=os.getenv("DB_HOST"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    database=os.getenv("DB_NAME")
)



@app.route("/login", methods=["GET", "POST"])
def login():

    if request.method == "POST":
        email = request.form["email"]
        senha = request.form["senha"]

        cursor = conexao.cursor(dictionary=True)

        cursor.execute("""
            SELECT *
            FROM usuario
            WHERE email = %s
            AND senha = SHA2(%s,256)
        """, (email, senha))

        usuario = cursor.fetchone()

        if usuario:
            session["usuario"] = usuario["nome_completo"]
            return redirect("/")

    return render_template("login.html")

@app.route("/logout")
def logout():
    session.clear()

    return redirect("/login")




@app.route("/")
def index():
    cursor = conexao.cursor(dictionary=True)

    cursor.execute("SELECT COUNT(*) total FROM usuario")
    total_usuarios = cursor.fetchone()

    cursor.execute("SELECT COUNT(*) total FROM questao")
    total_questoes = cursor.fetchone()

    cursor.execute("SELECT COUNT(*) total FROM simulado")
    total_simulados = cursor.fetchone()

    cursor.execute("SELECT COUNT(*) total FROM disciplina")
    total_disciplinas = cursor.fetchone()

    return render_template(
        "index.html",
        total_usuarios=total_usuarios,
        total_questoes=total_questoes,
        total_simulados=total_simulados,
        total_disciplinas=total_disciplinas
    )
@app.route("/usuarios")
def usuarios():

    cursor = conexao.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            nome_completo,
            email,
            area_interesse
        FROM usuario
    """)

    usuarios = cursor.fetchall()
    return render_template(
        "usuarios.html",
        usuarios=usuarios
    )
@app.route("/questoes")
def questoes():
    cursor = conexao.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            id_questao,
            enunciado,
            nivel_dificuldade,
            gabarito,
            comentario
        FROM questao
    """)

    questoes = cursor.fetchall()

    return render_template(
        "questoes.html",
        questoes=questoes
    )
@app.route("/questao/<int:id>")
def questao(id):
    cursor = conexao.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM questao
        WHERE id_questao = %s
    """, (id,))

    questao = cursor.fetchone()

    return render_template(
        "resolver_questao.html",
        questao=questao
    )
@app.route("/simulado")
def simulados():
    cursor = conexao.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            titulo,
            tema
        FROM simulado
    """)

    simulados = cursor.fetchall()

    return render_template(
        "simulado.html",
        simulados=simulados
    )
@app.route("/estatisticas")
def estatisticas():
    cursor = conexao.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            SUM(total_acertos) AS acertos,
            SUM(total_erros) AS erros,
            ROUND(AVG(tempo_medio),2) AS tempo
        FROM resultado
    """)

    estatisticas = cursor.fetchone()

    return render_template(
        "estatisticas.html",
        estatisticas=estatisticas
    )
if __name__ == "__main__":
    app.run(debug=True)