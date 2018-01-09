class exec3131{
	public static void main(String[] args) {
		
		//1) Imprima todos os numeros de 150 ate 300
		// int numero = 150;

		// for (int i = numero; i <=300 ; i=i+1) {
		// 	System.out.println(i);	
		// }ls 
		// int numero = 150;
		// while (numero <= 300) {
		// 	System.out.println("Numero: "+ numero);
		// 	numero = numero+1;
		// }

		// //2) Imprima a soma de todos os numeros de 1 ate 1000		
		// int soma = 0;
		// for (int contador = 1; contador <= 1000; contador=contador+1){		
		// 	soma = soma+contador;			
		// }
		// System.out.println(soma);

		//3) Imprima todos os multiplos de 3 entre 1 e 100
		// for (int numero = 1; numero <=100 ; numero=numero+1) {
		// 	if (numero % 3 == 0) {
		// 		System.out.println("Modulo de 3: " + numero);	
		// 	}			
		// }


		//4)Imprima os fatoriais de 1 a 10
		long fatorial = 1;		
		for (long contador = 1; contador<=10; contador=contador+1) {
			fatorial = fatorial*contador;	
			System.out.println(fatorial);		
		}

	}
}
