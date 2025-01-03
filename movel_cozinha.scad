// Dimensões gerais
altura_total = 2540;  // Altura total da estrutura em mm (2,54m)
altura_inferior = 915;  // Altura do móvel inferior em mm (91,5cm)
altura_superior = altura_total - altura_inferior;  // Altura do móvel superior
largura_inferior = 900;  // Largura do móvel inferior em mm (0,90m)
largura_superior = largura_inferior - 240;  // Largura do móvel superior reduzida em 24cm (660mm)
profundidade = 530;  // Profundidade dos móveis em mm (0,53m)

espessura_parede = 30;  // Espessura das paredes laterais em mm


// Dimensões do metalon
metalon_externo = 30;  // Espessura externa do metalon em mm
metalon_espessura = 1.5;  // Espessura da parede do metalon em mm

// Cores para debug
cor_estrutura = [0, 0, 0];
cor_paredes = [0.8, 0.8, 0.8];
cor_portas = [0, 0.7, 0.7];
cor_puxadores = [0.2, 0.2, 0.2];


// Função para criar o metalon com cores
module metalon(h, w, d, cor) {
    color(cor)
    difference() {
        cube([w, d, h], center = false);
        translate([metalon_espessura, metalon_espessura, metalon_externo])
            cube([w - 2 * metalon_espessura, d - 2 * metalon_espessura, h], center = false);
    }
}

// Função para gerar a estrutura de um móvel
module movel(altura, largura, pos_z, incluir_inferior = true, incluir_superior=true) {
    // Barras verticais (cantos)
    translate([0, 0, pos_z])
        metalon(altura, metalon_externo, metalon_externo, cor_estrutura);
    translate([largura - metalon_externo, 0, pos_z])
        metalon(altura, metalon_externo, metalon_externo, cor_estrutura);
    translate([0, profundidade - metalon_externo, pos_z])
        metalon(altura, metalon_externo, metalon_externo, cor_estrutura);
    translate([largura - metalon_externo, profundidade - metalon_externo, pos_z])
        metalon(altura, metalon_externo, metalon_externo, cor_estrutura);



    // Barras inferiores (opcional)
    if (incluir_inferior) {
        translate([0, 0, pos_z])
           metalon(metalon_externo, largura, metalon_externo, cor_estrutura);
        translate([0, profundidade - metalon_externo, pos_z])
           metalon(metalon_externo, largura, metalon_externo, cor_estrutura);
        translate([0, 0, pos_z])
           metalon(metalon_externo, metalon_externo, profundidade, cor_estrutura);
        translate([largura - metalon_externo, 0, pos_z])
           metalon(metalon_externo, metalon_externo, profundidade, cor_estrutura);
    }
    if (incluir_superior) {
    // Barras superiores
        translate([0, 0, pos_z + altura - metalon_externo])
            metalon(metalon_externo, largura, metalon_externo, cor_estrutura);
        translate([0, profundidade - metalon_externo, pos_z + altura - metalon_externo])
            metalon(metalon_externo, largura, metalon_externo, cor_estrutura);
        translate([0, 0, pos_z + altura - metalon_externo])
            metalon(metalon_externo, metalon_externo, profundidade, cor_estrutura);
        translate([largura - metalon_externo, 0, pos_z + altura - metalon_externo])
           metalon(metalon_externo, metalon_externo, profundidade, cor_estrutura);
    }
    
}


// Função para adicionar prateleiras dentro do móvel
module prateleira(largura, altura_z) {
    translate([0, 0, altura_z])
        metalon(metalon_externo, largura, metalon_externo, cor_estrutura);
    translate([0, profundidade - metalon_externo, altura_z])
        metalon(metalon_externo, largura, metalon_externo, cor_estrutura);
    translate([0, 0, altura_z])
        metalon(metalon_externo, metalon_externo, profundidade, cor_estrutura);
    translate([largura - metalon_externo, 0, altura_z])
        metalon(metalon_externo, metalon_externo, profundidade, cor_estrutura);
}





module laterais(largura, altura, pos_x, pos_z) {
    // Parede Esquerda
    color(cor_paredes)
    translate([pos_x, metalon_externo, pos_z + metalon_externo])
        cube([espessura_parede, profundidade - (metalon_externo * 2), altura - metalon_externo], center = false);

    // Parede Direita
    color(cor_paredes)
    translate([pos_x + largura - espessura_parede, metalon_externo, pos_z + metalon_externo])
        cube([espessura_parede, profundidade - (metalon_externo * 2), altura - metalon_externo], center = false);
}

module portas(largura, altura,  pos_x, pos_z){
     larg = (largura/2)-metalon_externo;
     alt = altura - metalon_externo;
     z_fim  = pos_z + metalon_externo;
    // Esquerda
    //  - Porta
    color(cor_portas)
        translate([pos_x+metalon_externo, 0, z_fim ])
    rotate([0, 0, -15])  // Abrir para fora no eixo Z
        
            cube([larg, espessura_parede, alt], center = false);
     // Puxador Esquerdo
    color(cor_puxadores)
    translate([pos_x + larg / 1.3, (metalon_externo / 2)-102, z_fim + alt / 2,])
    
        cylinder(h = 16, r = 8, center = false);
    // Direita
    color(cor_portas)
        translate([pos_x + larg+metalon_externo, 0, z_fim ])
            rotate([0, 0, 0])  // Abrir para fora no eixo Z
    mirror([0,0,0])
            cube([larg, espessura_parede, alt], center = false);
    // Puxador Direito
    color(cor_puxadores)
    translate([
        pos_x + larg + larg / 4.9 + metalon_externo, 
        (metalon_externo / 2)-25, 
        z_fim + alt / 2
    ])
        cylinder(h = 16, r = 8, center = false);
    
    
}

// Renderizar o móvel inferior
movel(altura_inferior, largura_inferior, 0); // Móvel inferior
prateleira(largura_inferior, altura_inferior / 2); // Prateleira no meio do móvel inferior
laterais( largura_inferior , (altura_inferior/2), 0, 0);
portas(largura_inferior , (altura_inferior/2), 0, 0);
laterais( largura_inferior , (altura_inferior/2)-metalon_externo, 0, (altura_inferior/2));
portas( largura_inferior , (altura_inferior/2)-metalon_externo, 0, (altura_inferior/2));
// Renderizar o móvel superior (sem barras inferiores)
movel(altura_superior, largura_superior, altura_inferior, false); // Móvel superior
prateleira(largura_superior, altura_inferior + 400); // Prateleira forno eletrico
laterais( largura_superior , 430, 0, altura_inferior-30);

prateleira(largura_superior, altura_inferior + 400 + 350 ); // Prateleira forno eletrico
laterais( largura_superior , 350, 0, altura_inferior+400);

prateleira(largura_superior, ((altura_superior - 750)/2) + altura_inferior + 750 ); // Prateleira superior
  laterais( 
    largura_superior , 
    ((altura_superior - 750)/2)+1, 
       0, ((altura_superior - 750)/2) + altura_inferior -30 +340 );
portas( 
    largura_superior , 
    ((altura_superior - 750)/2)+1, 
       0, ((altura_superior - 750)/2) + altura_inferior -30 +340 );       
 laterais( 
    largura_superior , 
    ((altura_superior - 750)/2)-30, 
       0, ((altura_superior - 750)/2) + altura_inferior + 750  );
portas( 
    largura_superior , 
    ((altura_superior - 750)/2)-30, 
       0, ((altura_superior - 750)/2) + altura_inferior + 750  );

translate([-580, 0,altura_superior-875])
    movel((altura_superior - 750), 600, altura_inferior, true); // Móvel superior
translate([-580, 0,altura_superior+40])
//color([0,0,1])
    prateleira(600, (altura_superior - 750)/2); // Prateleira superior
     
translate([-560, profundidade-650,0])
    color([1,1,1])
     cube([550, 650, 1630]); // Geladeira