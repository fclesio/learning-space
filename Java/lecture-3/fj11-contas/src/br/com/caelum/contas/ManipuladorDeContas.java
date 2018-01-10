package br.com.caelum.contas;

import br.com.caelum.contas.modelo.Conta;
import br.com.caelum.contas.modelo.ContaCorrente;
import br.com.caelum.contas.modelo.ContaPoupanca;
import br.com.caelum.javafx.api.util.Evento;

public class ManipuladorDeContas {
	private Conta conta; //Atributo
	
	//Aqui vamos criar uma nova conta já recebendo o objeto evento como argumento
//	public void criaConta(Evento evento) {
//		this.conta = new Conta();
//		this.conta.setTitular("Flavio");
//		this.conta.setAgencia("1234");
//		this.conta.setNumero(54321);
//	}
	
	
	public void criaConta(Evento evento){
		
		String tipo = evento.getSelecionadoNoRadio("tipo");
		
		if (tipo.equals("Conta Corrente")) {
			this.conta = new ContaCorrente();			
		} else if (tipo.equals("Conta Poupança")) {
			this.conta = new ContaPoupanca();		
		}
		
		
		//this.conta = new Conta(); //Tem que tirar pois estou criando o new ContaCorrente() que já herda o que tem na conta
		this.conta.setTitular(evento.getString("titular"));
		this.conta.setAgencia(evento.getString("agencia"));
		this.conta.setNumero(evento.getInt("numero"));
		
	}
	
	
//	public void deposita(Evento evento){
//		double valor = evento.getDouble("valor"); //Como vamos buscar um valor então usamos o get
//		this.conta.deposita(valor);
//	}
//	
//	public void saca(Evento evento){
//		double valor = evento.getDouble("valor");
//		this.conta.saca(valor);
//	}

		public void deposita(Evento evento){
		double valor = evento.getDouble("valorOperacao"); //Como vamos buscar um valor então usamos o get
		this.conta.deposita(valor);
	}

		public void saca(Evento evento){
		double valor = evento.getDouble("valorOperacao");
		if (this.conta.getTipo().equals("Conta Corrente")) {
			this.conta.saca(valor + 0.10);
		} else {
			this.conta.saca(valor);
		}
		//this.conta.saca(valor);
	}	
	
	

}
