package learning_jedis.learning_jedis;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import redis.clients.jedis.Jedis;

public class AprendendoJedis {

	public static void main(String[] args) throws IOException, InterruptedException {
		
		//Conectando o Jedis na instância local("localhost")  do 
		//Redis criando um novo objeto do tipo Jedis com o nome de "jedis"
		Jedis jedis = new Jedis("localhost");
		
		//Adicionando uma nova chave. Para adicionar uma chave e valor no Redis
		//precisamos apenas do comando "$ SET chave valor", e neste caso vamos 
		//chamar o método jedis.set() passando uma chave e um valor. 
		//Vamos adicionar algumas chaves.
		jedis.set("player_top_1", "Rafael Nadal");
		jedis.set("player_top_2", "Roger Federer");
	    jedis.set("player_top_3", "Grigor Dimitrov");
		jedis.set("player_top_4", "Alexander Zverev");
		jedis.set("player_top_5", "Dominic Thiem");
		jedis.set("player_top_6", "Marin Čilić");
		jedis.set("player_top_7", "David Goffin");
		jedis.set("player_top_8", "Stan Wawrinka");
		jedis.set("player_top_9", "Jack Sock");
		jedis.set("player_top_10", "Juan Martín del Potro");

		//Agora vamos buscar o valor da nossa chave. No Redis para buscar o valor
		//de uma chave, basta usar o comando "$ GET chave valor", mas neste caso
		//Vamos usar o comando jedis.get(chave).
		String goat = jedis.get("player_top_2");
		
		System.out.println("The best player of the history is: " + goat);
		System.out.println("Escolha uma posição para saber que jogador está ocupando hoje:");

		
		
		//Agora vamos ler do console e de acordo com o que colocarmos no teclado
		//Vamos receber o input na tela. Para isso vamos usar o InputStreamReader.
		BufferedReader bf = new BufferedReader(new InputStreamReader(System.in));
		
		//Agora vamos criar um objeto do tipo String para armazenar o que sera
		//colocado na linha 
		String leitura_console = bf.readLine();
		
		//Vamos exibir na tela o conteudo do que for escrito se houver uma chave	
		System.out.println("O jogador escolhido na posição foi:" + jedis.get(leitura_console));
		System.out.println("Insira abaixo uma chave e um valor.");
		
		//Vamos agora inserir um jogador na nossa base no Redis
		//Para isso vamos declarar dois objetos String, um para a chave
		//e outro para o valor e vamos dar o set e em seguida vamos exibir no console
		//o que foi exibido
		String chave = bf.readLine();
		String valor = bf.readLine();
				
		jedis.set(chave, valor);
		
		//Agora vamos modificar o valor do TTL de uma chave no Jedis
		jedis.expire(chave, 10);
		
		System.out.println("A chave inserida foi: " + chave +  "e o valor retornado foi: " + jedis.get(chave));
		
		//Vamos abrir uma thread de 1000 milisegundos
		Thread.sleep(3000);
		
		//Vamos ver agora o TTL da nossa chave
		System.out.println("O TTL da chave " + chave + " é de: " + jedis.ttl(chave));
		
		//Vamos deixar essa chave vencer e ver o valor dela
		Thread.sleep(10000);
		
		System.out.println("O TTL da chave " + chave + " é de: " + jedis.ttl(chave));
		
		//Vamos enviar ua mensagem de erro se a chave estiver expirada
		Long ttl_indicator = jedis.ttl(chave);
		
		if (ttl_indicator <= 0) {
			System.out.println("O TTL da chave " +  chave + " está expirado!");				
		}else {
			System.out.println("O TTL da chave " + chave + "está ativo!");
		}

		
		//Agora vamos fazer uma lista de jogadores
		String cacheKey = "jogadores";
		
		//Vamos fazer um conjunto SET e colocar como atributo usando o SADD (set ADD)
		 jedis.sadd(cacheKey,"Pele","Maradona","Messi","CR7","Ronaldo","Zidane","Romario");//SADD

		 //Vamos buscar todos os valores do conjunto usando o SMEMBERS
		 System.out.println("Melhores Jogadores: " + jedis.smembers(cacheKey));
		 
		 //Acionando novos jogadores
		 jedis.sadd(cacheKey,"Ronaldinho Bruxo","Luis Figo");
		 
		 //Getting the values... it doesn't allow duplicates
		 System.out.println("Jogadores: " + jedis.smembers(cacheKey));
		
		
		
	}

}
