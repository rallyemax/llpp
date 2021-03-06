open Printf

let r_dash = Str.regexp " - ";;
let tabify s =
  let dashpos = try Str.search_forward r_dash s 0 with Not_found -> -1 in
  if dashpos < 1
  then
    s
  else
    let rec findnonwsback i =
      if i = -1 then 0 else
        if s.[i] = ' '
        then findnonwsback (i-1)
        else i
    in
    let nonwspos = findnonwsback dashpos in
    if nonwspos = -1
    then s
    else
      let b = Buffer.create 80 in
      Buffer.add_substring b s 0 (nonwspos+1);
      Buffer.add_char b '\t';
      Buffer.add_substring b s (dashpos+1) (String.length s - dashpos - 1);
      Buffer.contents b
;;

let lines =
  let lines =
    let rec fold accu =
      match (try Some (input_line stdin) with _ -> None) with
      | Some line -> fold (tabify line :: accu)
      | None -> List.rev accu
    in
    fold []
  in
  lines
;;

let _ =
  printf "let keys = [\n";
  List.iter (fun l -> printf "  %S;\n" l) lines;
  printf "];;\n"
;;
