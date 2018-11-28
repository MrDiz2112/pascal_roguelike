program arena;

uses crt;
label m1, m2, mm, m3, m4, m5, me, md;
var
  x, y, pclass, gd, xg, yg, pd, pl, bgd, bph, bpd, bpl, xc, yc, weap, arm, pweap, parm: shortint;
  movekey: char;
  runloop: boolean;
  health, maxh, ghealth, bgh, score, kchest, schest, level: integer;
  pn, pc, pw, pa: string;

procedure draw;{Прорисовка героя}
begin
  gotoxy(x, y);
  case level of
    1: textcolor(15);
    2: textcolor(10);
    3: textcolor(2);
    4: textcolor(3);
    5: textcolor(14);
    6: textcolor(12);
    7: textcolor(4);
    8: textcolor(13);
    9: textcolor(5);
  else textcolor(9);
  end;
  write('@');
  textcolor(white);
end;

procedure drawg;{Прорисовка противника}
begin
  gotoxy(xg, yg);
  write('g');
end;

procedure combat;{Расчет здоровья во время боя}
var
  ch: word;
begin
  randomize;
  ch := random(10);
  if ch > pl then begin
    if gd < 0 then gd := 0;
    health := health - gd;
    if health > maxh then health := maxh;
    gotoxy(1, 22);
    if health <= 0 then health := 0;
    writeln('Противник атаковал вас! Теперь ваше здоровье ', health);
  end
  else begin
    gotoxy(1, 22);
    writeln('Противник промахнулся');
  end;
  ch := random(10);
  if ch > pl then begin
    ghealth := ghealth - pd;
    gotoxy(1, 23);
    if ghealth <= 0 then ghealth := 0;
    writeln('Вы атаковали противника! Теперь его здоровье ', ghealth);
  end
  else begin
    gotoxy(1, 23);
    writeln('Вы промахнулись');
  end;
  readkey;
end;

procedure ifcombat;{Проверка условий для боя}
begin
  if (xg = x) and (yg = y) then combat;
end;



procedure moveup;{Ниже процедуры для движения персонажа}
begin
  if (y > 2) or ((x = 10) and (y = 2)) then begin
    y := y - 1;
    if (xg = x) and (yg = y) then begin
      y := y + 1;
      combat;
    end;
    draw;
  end;
end;

procedure movedown;
begin
  if y < 20 then begin
    y := y + 1;
    if (xg = x) and (yg = y) then begin
      y := y - 1;
      combat;
    end;
    draw;
  end;
end;

procedure moveleft;
begin
  if x > 2 then begin
    x := x - 1;
    if (xg = x) and (yg = y) then begin
      x := x + 1;
      combat;
    end;
    draw;
  end;
end;

procedure moveright;
begin
  if x < 20 then begin
    x := x + 1;
    if (xg = x) and (yg = y) then begin
      x := x - 1;
      combat;
    end;
    draw;
  end;
end;

procedure gmoveup;{Ниже процедуры для движения врага}
begin
  if yg > 2 then begin
    yg := yg - 1;
    if (xg = x) and (yg = y) then yg := yg + 1;
    if (xg = xc) and (yg = yc) then yg := yg + 1;
    drawg;
  end;
end;

procedure gmovedown;
begin
  if yg < 20 then begin
    yg := yg + 1;
    if (xg = x) and (yg = y) then yg := yg - 1;
    if (xg = xc) and (yg = yc) then yg := yg - 1;
    drawg;
  end;
end;

procedure gmoveleft;
begin
  if xg > 2 then begin
    xg := xg - 1;
    if (xg = x) and (yg = y) then xg := xg + 1;
    if (xg = xc) and (yg = yc) then xg := xg + 1;
    drawg;
  end;
end;

procedure gmoveright;
begin
  if xg < 20 then begin
    xg := xg + 1;
    if (xg = x) and (yg = y) then xg := xg - 1;
    if (xg = xc) and (yg = yc) then xg := xg - 1;
    drawg;
  end;
end;

procedure room;{Прорисовка арены}
var
  i, j: integer;
begin
  clrscr;
  for i := 2 to 20 do 
  begin{Примечание: в самой программе используются другие }  
    gotoxy(i, 1);     {символы}
    write('#');
    gotoxy(i, 21);
    write('#');
  end;
  gotoxy(1, 1);
  write('#');
  gotoxy(21, 1);
  write('#');
  gotoxy(1, 21);
  write('#');
  gotoxy(21, 21);
  write('#');
  for j := 2 to 20 do 
  begin
    gotoxy(1, j);
    write('#');
    gotoxy(21, j);
    write('#');
  end;
  gotoxy(10, 1);
  write('#');
end;

procedure ppar;{Повышение параметров игрока с новым уровнем}
begin
  if score mod 3 = 0 then begin
    maxh := bph;
    maxh := maxh + 5;
    health := maxh;
    bph := maxh;
    bpd := pd;
    bpd := bpd + 2;
    pd := bpd;
    bpl := pl;
    bpl := bpl + 1;
    if bpl >= 8 then bpl := 8;
    pl := bpl;
    level := level + 1
  end;
end;

procedure player;{Информация о герое}
begin
  gotoxy(23, 1);
  writeln('Персонаж ', pn);
  gotoxy(23, 2);
  write(pc);
  gotoxy(23, 3);
  writeln('Здоровье:');
  gotoxy(23, 4);
  writeln('', health, ' из ', maxh, '');
  gotoxy(23, 5);
  writeln('Сила атаки:  ', pd);
  gotoxy(23, 6);
  writeln('Ловкость : ', pl);
  gotoxy(23, 7);
  writeln('Убито монстров:  ', score);
  gotoxy(23, 8);
  writeln('Уровень:  ', level);
  gotoxy(23, 9);
  writeln('Оружие и броня:');
  gotoxy(23, 10);
  writeln('Оружие -  ', pw);
  gotoxy(23, 11);
  writeln('Броня -  ', pa);
end;


procedure move;{Движение врага и проверка на условие для боя}
var
  k, k1: integer;
begin
  randomize;
  k1 := 0;
  while k1 <> 1 do 
  begin
    if (xg = x) or (yg = y) then break;
    if (xg < x) and (yg < y) then begin
      k := random(2);
      case k of
        1: gmoveright;
        0: gmovedown;
      end;
      k1 := 1;
    end;
    if (xg < x) and (yg > y) then begin
      k := random(2);
      case k of
        1: gmoveright;
        0: gmoveup;
      end;
      k1 := 1;
    end;
    if (xg > x) and (yg < y) then begin
      k := random(2);
      case k of
        1: gmoveleft;
        0: gmovedown;
      end;
      k1 := 1;
    end;
    if (xg > x) and (yg > y) then begin
      k := random(2);
      case k of
        1: gmoveleft;
        0: gmoveup;
      end;
      k1 := 1;
    end;
  end;
  while k1 <> 1 do 
  begin
    if (xg = x) and (yg > y) then begin
      gmoveup;
      ifcombat;
      k1 := 1;
    end;
    if (xg > x) and (yg = y) then begin
      gmoveleft;
      ifcombat;
      k1 := 1;
    end;
    if (xg = x) and (yg < y) then begin
      gmovedown;
      ifcombat;
      k1 := 1;
    end;
    if (xg < x) and (yg = y) then begin
      gmoveright;
      ifcombat;
      k1 := 1;
    end;
  end;
end;


procedure chestkoord;{Координаты сундука}
begin
  xc := random((22) - 2);
  yc := random((22) - 2);
  if (xc = 1) and (yc in [1..20]) then begin
    xc := 2;
    yc := 2;
  end;
  if (xc = 20) and (yc in [1..20]) then begin
    xc := 19;
    yc := 2;
  end;
  if (yc = 1) and (xc in [1..20]) then begin
    xc := 2;
    yc := 19;
  end;
  if (yc = 20) and (xc in [1..20]) then begin
    xc := 19;
    yc := 19;
  end;
  if (xc = x) and (yc = y) then begin
    xc := 2;
    yc := 19;
  end;
  if (xc = xg) and (yc = yg) then begin
    xc := 19;
    yc := 2;
  end;
end;


procedure chest;{Прорисовка и содержимое сундука}
begin
  randomize;
  if (xc <> x) and (yc <> y) and (kchest <> 1) then begin
    gotoxy(xc, yc);
    textcolor(10);
    write('▄');
    textcolor(15);
  end;
  if (xc = x) and (yc <> y) and (kchest <> 1) then begin
    gotoxy(xc, yc);
    textcolor(10);
    write('▄');
    textcolor(15);
  end;
  if (xc <> x) and (yc = y) and (kchest <> 1) then begin
    gotoxy(xc, yc);
    textcolor(10);
    write('▄');
    textcolor(15);
  end;
  if (x = xc) and (y = yc) and (kchest <> 1) then begin
    xc := 0;
    yc := 0;
    schest := 0;
    kchest := 1;
    weap := random(10);
    arm := random(10);
    case weap of
      0: 
        begin
          if weap <= pweap then begin
            pweap := pweap;
            pw := pw;
          end
          else begin
            pw := 'кинжал (+1 к урону)';
            pd := pd + 1;
          end;
        end;
      1: 
        begin
          if weap <= pweap then begin
            pweap := pweap;
            pw := pw;
          end
          else begin
            pw := 'ржавый меч(+2 к урону)';
            pd := pd + 2;
          end;
        end;
      2: 
        begin
          if weap <= pweap then begin
            pweap := pweap;
            pw := pw;
          end
          else begin
            pw := 'тупой меч(+3 к урону)';
            pd := pd + 3;
          end;
        end;
      3: 
        begin
          if weap <= pweap then begin
            pweap := pweap;
            pw := pw;
          end
          else begin
            pw := 'меч (+4 к урону)';
            pd := pd + 4;
          end;
        end;
      4: 
        begin
          if weap <= pweap then begin
            pweap := pweap;
            pw := pw;
          end
          else begin
            pw := 'заточенный меч(+5 к урону)';
            pd := pd + 5;
          end;
        end;
      5: 
        begin
          if weap <= pweap then begin
            pweap := pweap;
            pw := pw;
          end
          else begin
            pw := 'облегченный меч(+6 к урону)';
            pd := pd + 6;
          end;
        end;
      6: 
        begin
          if weap <= pweap then begin
            pweap := pweap;
            pw := pw;
          end
          else begin
            pw := 'ржавый палаш(+7 к урону)';
            pd := pd + 7;
          end;
        end;
      7: 
        begin
          if weap <= pweap then begin
            pweap := pweap;
            pw := pw;
          end
          else begin
            pw := 'палаш (+8 к урону)';
            pd := pd + 8;
          end;
        end;
      8: 
        begin
          if weap <= pweap then begin
            pweap := pweap;
            pw := pw;
          end
          else begin
            pw := 'тяжелый палаш(+9 к урону)';
            pd := pd + 9;
          end;
        end;
      9: 
        begin
          if weap <= pweap then begin
            pweap := pweap;
            pw := pw;
          end
          else begin
            pw := 'меч паладина(+10 к урону)';
            pd := pd + 10;
          end;
        end;
    end;
    case arm of
      0: 
        begin
          if arm <= parm then begin
            parm := parm;
            pa := pa;
          end
          else begin
            pa := 'накидка (+1 к защите)';
            gd := gd - 1;
          end;
        end;
      1: 
        begin
          if arm <= parm then begin
            parm := parm;
            pa := pa;
          end
          else begin
            pa := 'Кожанная куртка (+2 к защите)';
            gd := gd - 2;
          end;
        end;
      2: 
        begin
          if arm <= parm then begin
            parm := parm;
            pa := pa;
          end
          else begin
            pa := 'кольчуга (+3 к защите)';
            gd := gd - 3;
          end;
        end;
      3: 
        begin
          if arm <= parm then begin
            parm := parm;
            pa := pa;
          end
          else begin
            pa := 'ржавый доспех(+4 Є § йЁвҐ)';
            gd := gd - 4;
          end;
        end;
      4: 
        begin
          if arm <= parm then begin
            parm := parm;
            pa := pa;
          end
          else begin
            pa := 'доспех(+5 к защите)';
            gd := gd - 5;
          end;
        end;
      5: 
        begin
          if arm <= parm then begin
            parm := parm;
            pa := pa;
          end
          else begin
            pa := 'тяжелый доспех(+6 к защите)';
            gd := gd - 6;
          end;
        end;
      6: 
        begin
          if arm <= parm then begin
            parm := parm;
            pa := pa;
          end
          else begin
            pa := 'ржавые латы(+7 к защите)';
            gd := gd - 7;
          end;
        end;
      7: 
        begin
          if arm <= parm then begin
            parm := parm;
            pa := pa;
          end
          else begin
            pa := 'латы(+8 к защите)';
            gd := gd - 8;
          end;
        end;
      8: 
        begin
          if arm <= parm then begin
            parm := parm;
            pa := pa;
          end
          else begin
            pa := 'тяжелые латы(+9 к защите)';
            gd := gd - 9;
          end;
        end;
      9: 
        begin
          if arm <= parm then begin
            parm := parm;
            pa := pa;
          end
          else begin
            pa := 'доспех паладина(+10 к защите)';
            gd := gd - 10;
          end;
        end;
    end;
    pweap := weap;
    kchest := 1;
    chestkoord;
  end;
end;

procedure ifchest;{Проверка на прорисовку сундука}
begin
  if ((schest = 1) or (schest mod 4 = 0)) and (schest <> 0) then begin
    chest;
    kchest := 0;
  end
  else kchest := 0;
end;

procedure goblin;{Движение врага и повышение его параметров при смерти}
begin
  if ghealth > 0 then move
  else begin
    ghealth := bgh;
    ghealth := ghealth + 2;
    bgh := ghealth;
    xg := random((22) - 2);
    yg := random((22) - 2);
    if (xg = xc) and (yg = yc) then begin
      xg := xc + 1;
      yg := yc + 1;
    end;
    if (xg = y) and (yg = y) then begin
      xg := 19;
      yg := 19;
    end;
    if (xg = 0) and (yg = 0) then begin
      xg := 2;
      yg := 2;
    end;
    if (xg = 1) and (yg = 20) then begin
      xg := 2;
      yg := 19;
    end;
    if (xg = 20) and (yg = 1) then begin
      xg := 19;
      yg := 2;
    end;
    if (yg = 1) and (xg = 1) then begin
      xg := 2;
      yg := 2;
    end;
    if (yg = 20) and (xg = 20) then begin
      xg := 19;
      yg := 19;
    end;
    if (xg = 1) and (yg in [2..19]) then xg := xg + 1;
    if (xg = 20) and (yg in [2..19]) then xg := xg - 1;
    if (yg = 1) and (xg in [2..19]) then yg := yg + 1;
    if (yg = 20) and (xg in [2..19]) then yg := yg - 1;
    score := score + 1;
    schest := 0;
    schest := schest + score;
    gd := bgd;
    gd := gd + 1;
    bgd := gd;
    ppar;
  end;
  ifchest;
end;

procedure death;{Окно, появляющееся после обнуления здоровья}
begin{Примечание: разметка оригинала не сохранена}
  clrscr;
  writeln('        __________________                                     ');
  writeln('       /_________________/\         Убито врагов - ', score   );
  writeln('      /                  \ \        Счет - ', score * 10         );
  writeln('     /                    \ \       Уровень - ', level);
  writeln('    /                      \ \                                 ');
  writeln('   |                        | |                                ');
  writeln('   |    Погиб, сражаясь на      | |                                ');
  writeln('   |        арене...     | |                                ');
  writeln('   |                        | |                                ');
  writeln('   |                        | |                                ');
  writeln('   |   Вечная память тебе,  | |                                ');
  writeln('   |   ', pn);
  gotoxy(29, 12);
  write('|');
  gotoxy(31, 12);
  write('|');
  gotoxy(1, 13);
  writeln('   |                        | |                                ');
  writeln('   |                        | |                                ');
  writeln('   |                        | |                                ');
  writeln('   |                        | |                                ');
  writeln('   |                        | |                                ');
  writeln('   |                        | |                                ');
  writeln('   |                        | |                                ');
  writeln('   |                        | |                                ');
  writeln('   |                        | |                                ');
  writeln('   |                        | |                                ');
  writeln('   |                        | |                                ');
  readkey;
  readkey;
end;

procedure toexit;{Окно, появляющееся при выходе с арены}
begin
  clrscr;
  writeln('');
  writeln('');
  writeln('                    Вы вышли с арены');
  writeln('');
  writeln('');
  writeln('Неплохо. Ты расправился с ', score, ' противниками.');
  writeln('Твой счет - ', score * 10, ',   а уровень - ', level);
  writeln('Вот тебе ', score * 100 + level * 3, ' золота.');
  writeln('Приходи снова, если захочешь.');
  readkey;
end;

procedure arenagame;{Описание игры на арене}
begin
  clrscr; {Примечание: вступительная речь вырезанна}
  writeln('…');
  readkey;
  clrscr;
  
  chestkoord;
  while runloop and (health > 0)  do
  begin
    room;
    draw;
    goblin;
    player;
    ifchest;
    gotoxy(0, 0);
    movekey := readkey;
    case movekey of
      #72: moveup;
      #75: moveleft;
      #80: movedown;
      #77: moveright;
      #27: break;
    end;
    if (x = 10) and (y = 1) then break;
  end;
  if (x = 10) and (y = 1) then toexit;
  if health = 0 then death;
end;

begin
  Randomize;
  
  x := 10;
  y := 2;
  mm:
  xg := random((22) - 2);
  yg := random((22) - 2);
  if (xg = y) and (yg = y) then goto mm;
  if (xg = 0) and (yg = 0) then goto mm;
  if (xg = 1) and (yg = 20) then goto mm;
  if (xg = 20) and (yg = 1) then goto mm;
  if (yg = 1) and (xg = 1) then goto mm;
  if (yg = 20) and (xg = 20) then goto mm;
  if (xg = 1) and (yg in [2..19]) then xg := xg + 1;
  if (xg = 20) and (yg in [2..19]) then xg := xg - 1;
  if (yg = 1) and (xg in [2..19]) then yg := yg + 1;
  if (yg = 20) and (xg in [2..19]) then yg := yg - 1;
  bgd := 3;
  bgh := 10;
  ghealth := bgh;
  gd := bgd;
  level := 1;
  runloop := true;
  clrscr;    {Логотип. Разметка оригинала не сохранена}
  writeln('                   #      ###   ######  #    #      #      ');
  writeln('                  # #     #  #  #       #    #     # #     ');
  writeln('                 #   #    #  #  #       #    #    #   #    ');
  writeln('                #######   ###   ######  ######   #######   ');
  writeln('                #     #   #     #       #    #   #     #   ');
  writeln('                #     #   #     #       #    #   #     #   ');
  writeln('                #     #   #     ######  #    #   #     #   ');
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln;
  writeln('Нажмите любую клавишу');
  writeln;
  writeln('v 1.0                                                     Автор: Лукин Вадим');
  readkey;
  clrscr;
  writeln('Введите ваше имя');
  readln(pn);
  m2:
  clrscr;
  writeln('Выберите вашу расу, ', pn);
  writeln('1) Человек');
  writeln('2) Гном');
  writeln('3) Эльф');
  readln(pclass);
  if pclass > 3 then goto m2;
  case pclass of
    1: 
      begin
        pc := 'Человек';
        bpd := 5;
        bpl := 5;
        pd := bpd;
        pl := bpl;
        bph := 30;
        health := bph;
        maxh := bph;
      end;
    2: 
      begin
        pc := 'Гном';
        bpd := 6;
        bpl := 4;
        pd := bpd;
        pl := bpl;
        bph := 25;
        health := bph;
        maxh := bph;
      end;
    3: 
      begin
        pc := 'Эльф';
        bpd := 4;
        bpl := 6;
        pd := bpd;
        pl := bpl;
        bph := 35;
        health := bph;
        maxh := bph;
      end;
  end;
  arenagame;
end.