/* Função Objetivo */
min: 7 y72 + 7 y73 - 7 y92 - 7 y114 - 7 y103 + 10 y102 + 10 y103 + 10 y104 + 10 y105 + 11 y112 + 11 y113 + 11 y114 + 11 y115;


/* Restrições do Modelo */
numerodecontentoresdetamanho2: y32 + 2 y42 + y52 + y62 + y82 + y92 + y102 + y112 + y72 >= 13;

numerodecontentoresdetamanho3: y43 + y52 + 2 y63 + y73 + y83 + y93 + y103 + y113 - y32 >= 10;

numerodecontentoresdetamanho4: y54 + y62 + y73 + 2 y84 + y94 + y104 + y114 - y42 - y43 >= 15;

numerodecontentoresdetamanho5: y65 + y83 + y94 + y115 + y72 + 2 y105 - y52 - y54 >= 5;

numerodecontentoresdetamanho6: y82 + y93 + y104 + y115 - y62 - y63 - y65 >= 0;

numerodecontentoresdetamanho8: y113 + y102 - y82 - y84 - y83 >= 0;

numerodecontentoresdetamanho9: y112 - y92 - y94 - y93 >= 0;

numerodecontentoresdetamanho7minimo: y72 + y73 - y92 - y114 - y103 >= 0;

numerodecontentoresdetamanho7maximo: y72 + y73 - y92 - y114 - y103 <= 4;

numerodecontentoresdetamanho10minimo: y102 + y103 + y104 + y105 >= 0;

numerodecontentoresdetamanho10maximo: y102 + y103 + y104 + y105 <= 5;

numerodecontentoresdetamanho11minimo: y112 + y113 + y114 + y115 >= 0;

int y32, y42,y43 y52, y54, y62,y63, y65, y72, y73, y82, y83, y84, y92, y94, y93, y102,y103, y104, y105, y112,y113, y114, y115, y103;