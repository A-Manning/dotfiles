

open FSharpx.Functional.Prelude
open FSharp_i3wm
open FSharp_i3wm.Message

module Option = FSharpx.Option
module String = FSharpx.String

let logFile = "/home/ash/i3log.txt"

let log (s: string): unit =
    System.IO.File.AppendAllLines(logFile, [s])

let clearLog(): unit =
    System.IO.File.WriteAllText(logFile, "")

let (>>!) (f: 'A -> 'B) (g: 'B -> unit): 'A -> 'B =
    fun x -> f x |>! g

let rec waitUntil (stopCondition: Tree.T -> bool): unit =
    if stopCondition ^ getTree() then () else waitUntil stopCondition

let rec doUntil (action:unit -> unit) (stopCondition: Tree.T -> bool): unit =
    if stopCondition ^ getTree() then ()
    else action(); doUntil action stopCondition

let focusedName: Tree.T -> option<string> =
    Tree.getFocused >> Option.map Tree.getName

let getFocusedName: unit -> option<string> =
    getTree >> focusedName

let logFocusedName: unit -> unit =
    Option.iter log << getFocusedName

let focusedNameHasPrefix (prefix: string): Tree.T -> bool =
    focusedName
    >> Option.map ^ String.startsWith prefix
    >> Option.getOrElse false

let focusedNameHasSuffix (suffix: string): Tree.T -> bool =
    focusedName
    >> Option.map ^ String.endsWith suffix
    >> Option.getOrElse false

(******************************************************************************)
(* Set up left screen                                                         *)
(******************************************************************************)

let tabs = [
    "zendev-team.slack.com";
    "functionalprogramming.slack.com";
    "github.com/FStarLang/FStar";
    "gitlab.com/zenprotocol";
    "coinmarketcap.com";
]
let execTerm (cmd: string) =
    exec ^ sprintf "gnome-terminal --execute zsh -is eval '%s'" cmd
let execCmus() = execTerm "cmus"
let execZenNode() =
    execTerm "cd ~/Programs/zenprotocol/src/Node/bin/Debug/ && ./zen-node"
let execCGMiner() =
    execTerm "cd ~/Mining/cgminer_keccak/ && ./cgminer --keccak -D --verbose -T -u x -p x -o \"http://127.0.0.1:11567\""
let execChromium() =
    let args = tabs |> String.concat " "
    exec ^ sprintf "exec chromium-browser %s" args

let execNitrogen() =
    exec "nitrogen --restore"

let initLeft(): unit =
    focusOutput "HDMI-A-0"
    log "focused HDMI-A-0"
    workspace "1"
    printfn "p1"
    log "trying to focus 1"
    log "focused name is:"
    logFocusedName()
    waitUntil ^ focusedNameHasPrefix "1"
    log "focused 1"
    layoutToggleSplit()
    (* *[]* *)
    execCmus()
    log "exec cmus"
    log "trying to focus cmus"
    log "focused name is"
    logFocusedName()
    waitUntil ^ focusedNameHasPrefix "cmus"
    log "focused cmus"
    split "vertical"
    (* [*cmus*] *)
    exec "telegram"
    log "exec telegram"
    waitUntil ^ focusedNameHasPrefix "Telegram"
    log "focused Telegram"
    logFocusedName()
    (* [cmus      ]
       [*Telegram*] *)
    split "horizontal"
    layout "tabbed"

    (*
    exec "qbittorrent"
    log "exec qBittorrent"
    logFocusedName()
    waitUntil ^ focusedNameHasPrefix "qBittorrent"
    (* [cmus                  ]
       [Telegram|*qBittorrent*] *)
    log "focused qBittorrent"
    logFocusedName()
    focus "left"
    log "focus left"
    logFocusedName()
    waitUntil ^ focusedNameHasPrefix "Telegram"
    (* [cmus                  ]
       [*Telegram*|qBittorrent] *)
    log "focused Telegram"
    logFocusedName()
    *)
    focus "up"
    log "focus up"
    logFocusedName()
    waitUntil ^ focusedNameHasPrefix "cmus"
    (* [*cmus              *]
       [Telegram|qBittorrent] *)
    log "focused cmus"
    split "horizontal"
    layout "tabbed"
    focus "parent"
    log "focused parent"
    logFocusedName()
    (* *[cmus                ]*
        [Telegram|qBittorrent]  *)
    focus "parent"
    log "focused parent"
    logFocusedName()
    waitUntil ^ focusedNameHasPrefix "1"
    (* *[cmus                ]*
       *[Telegram|qBittorrent]* *)
    log "focused 1"
    logFocusedName()
    split "horizontal"
    //exec "chromium-browser"
    execChromium()
    log "exec chromium-browser"
    logFocusedName()
    waitUntil ^ focusedNameHasSuffix "Chromium"
    (* [cmus                ]⌈*Chromium*⌉
       [Telegram|qBittorrent]⌊ 	        ⌋ *)
    log "focused Chromium"
    split "horizontal"
    layout "tabbed"
    log "finished init left"

(******************************************************************************)
(* Set up right screen                                                        *)
(******************************************************************************)

let initRight(): unit =
    focusOutput "HDMI-A-1"
    workspace "2"
    log "workspace 2"
    logFocusedName()
    waitUntil ^ focusedNameHasPrefix "2"
    (* [] *)
    log "focused 2"
    exec "gnome-terminal"
    log "exec gnome-terminal"
    logFocusedName()
    waitUntil ^ focusedNameHasPrefix "Terminal"
    (* [*Terminal*] *)
    log "focused Terminal"
    focus "parent"
    log "focus parent"
    logFocusedName()
    waitUntil ^ (not << focusedNameHasPrefix "Terminal")
    log "focused parent"
    logFocusedName()
    (* *[Terminal]* *)
    exec "gnome-terminal"
    log "exec gnome-terminal"
    logFocusedName()
    waitUntil ^ focusedNameHasPrefix "Terminal"
    log "focused Terminal"
    layout "tabbed"
    (* [Terminal|*Terminal*] *)
    focus "left"
    log "focus left"
    logFocusedName()
    (* [*Terminal*|Terminal] *)
    //clearLog()
    log "finished init right"

[<EntryPoint>]
let main argv =
    execNitrogen();
    match argv with
    | [|"Left"|]  ->
        initLeft()
        0
    | [|"Right"|] ->
        initRight()
        0
    | [|"Both"|] ->
        clearLog()
        initLeft()
        initRight()
        workspace "1"
        log "workspace 1"
        log "finished init both"
        0
    | [||] ->
        failwith "Must provide an argument."
    | args ->
        failwithf "unrecognised argument: %s" ^ Array.head args
