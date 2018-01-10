package br.com.caelum.contas;

import br.com.caelum.contas.modelo.Conta;
import br.com.caelum.javafx.api.util.Evento;

public class ManipuladorDeContas {
	private Conta conta; //Atributo
	
	//Aqui vamos criar uma nova conta já recebendo o objeto evento como argumento
	public void criaConta(Evento evento) {
		this.conta = new Conta();
		this.conta.setTitular("Flavio");
		this.conta.setAgencia("1234");
		this.conta.setNumero(54321);
	}
	
	public void deposita(Evento evento){
		double valor = evento.getDouble("valor"); //Como vamos buscar um valor então usamos o get
		this.conta.deposita(valor);
	}
	
	public void saca(Evento evento){
		double valor = evento.getDouble("valor");
		this.conta.saca(valor);
	}
	

}
