{
module Main (Token(..), AlexPosn(..), alexScanTokens, token_posn, main) where
import System.Environment
import System.IO
}

-- Positional wrapper
%wrapper "posn"

-- Macros
$digit = 0-9            -- digits
$alpha = [a-zA-Z]       -- alphabetic characters

-- Each right-hand side has type :: AlexPosn -> String -> Token
tokens :-
    $white+                             ;
    "#".*                               ;
    program                             { tok (\p s -> TokProgram p) }
    using                               { tok (\p s -> TokUsing p) }
    in                                  { tok (\p s -> TokIn p) }
    int                                 { tok (\p s -> TokIntT p) }
    $digit+                             { tok (\p s -> TokInt p (read s)) }
    bool                                { tok (\p s -> TokBoolT p) }
    [Tt]rue                             { tok (\p s -> TokBool p True) }
    [Ff]alse                            { tok (\p s -> TokBool p False) }
    set                                 { tok (\p s -> TokSetT p) }
    [\{]                                { tok (\p s -> TokCurlyOpen p) }
    [\}]                                { tok (\p s -> TokCurlyClose p) }
    [\(]                                { tok (\p s -> TokParenOpen p) }
    [\)]                                { tok (\p s -> TokParenClose p) }
    [\,]                                { tok (\p s -> TokComma p) }
    [\;]                                { tok (\p s -> TokSemicolon p) }
    [\:]                                { tok (\p s -> TokColon p) }
    [=]                                 { tok (\p s -> TokAssign p) }
    [\+\-\*\/\%]                        { tok (\p s -> TokIntOp p s) }
    (\+\+)|(\\)|(\>\<)                  { tok (\p s -> TokSetBinOp p s) }
    [\>\<\$]\?                          { tok (\p s -> TokSetUnOp p s) }
    \<[\+\-\*\/\%]\>                    { tok (\p s -> TokMapOp p s) }
    (and)|(or)|(not)                    { tok (\p s -> TokBoolOp p s) }
    (\<=?)|(\>=?)|(==)|(\/=)|@          { tok (\p s -> TokRelOp p s) }
    if                                  { tok (\p s -> TokIf p) }
    then                                { tok (\p s -> TokThen p) }
    else                                { tok (\p s -> TokElse p) }
    for                                 { tok (\p s -> TokFor p) }
    min                                 { tok (\p s -> TokMin p) }
    max                                 { tok (\p s -> TokMax p) }
    repeat                              { tok (\p s -> TokRepeat p) }
    while                               { tok (\p s -> TokWhile p) }
    do                                  { tok (\p s -> TokDo p) }
    def                                 { tok (\p s -> TokDef p) }
    \-\>                                { tok (\p s -> TokArrow p) }
    return                              { tok (\p s -> TokReturn p) }
    scan                                { tok (\p s -> TokScan p) }
    print                               { tok (\p s -> TokPrint p) }
    println                             { tok (\p s -> TokPrintln p) }
    \"[^\"]*\"                          { tok (\p s -> TokString p (read s)) }
    $alpha [$alpha $digit \_ \']*       { tok (\p s -> TokVar p s) }

{
tok f p s = f p s

data Token = TokProgram AlexPosn
           | TokUsing AlexPosn
           | TokIn AlexPosn
           | TokIntT AlexPosn
           | TokInt AlexPosn Int
           | TokBoolT AlexPosn
           | TokBool AlexPosn Bool
           | TokSetT AlexPosn
           | TokCurlyOpen AlexPosn
           | TokCurlyClose AlexPosn
           | TokParenOpen AlexPosn
           | TokParenClose AlexPosn
           | TokComma AlexPosn
           | TokSemicolon AlexPosn
           | TokColon AlexPosn
           | TokAssign AlexPosn
           | TokIntOp AlexPosn String
           | TokSetBinOp AlexPosn String
           | TokSetUnOp AlexPosn String
           | TokMapOp AlexPosn String
           | TokBoolOp AlexPosn String
           | TokRelOp AlexPosn String
           | TokIf AlexPosn
           | TokThen AlexPosn
           | TokElse AlexPosn
           | TokFor AlexPosn
           | TokMin AlexPosn
           | TokMax AlexPosn
           | TokRepeat AlexPosn
           | TokWhile AlexPosn
           | TokDo AlexPosn
           | TokDef AlexPosn
           | TokArrow AlexPosn
           | TokReturn AlexPosn
           | TokScan AlexPosn
           | TokPrint AlexPosn
           | TokPrintln AlexPosn
           | TokString AlexPosn String
           | TokVar AlexPosn String
           deriving (Eq, Show)

token_posn(TokProgram p) = p
token_posn(TokUsing p) = p
token_posn(TokIn p) = p
token_posn(TokIntT p) = p
token_posn(TokInt p _) = p
token_posn(TokBoolT p) = p
token_posn(TokBool p _) = p
token_posn(TokSetT p) = p
token_posn(TokCurlyOpen p) = p
token_posn(TokCurlyClose p) = p
token_posn(TokParenOpen p) = p
token_posn(TokParenClose p) = p
token_posn(TokComma p) = p
token_posn(TokSemicolon p) = p
token_posn(TokColon p) = p
token_posn(TokAssign p) = p
token_posn(TokIntOp p _) = p
token_posn(TokSetBinOp p _) = p
token_posn(TokSetUnOp p _) = p
token_posn(TokMapOp p _) = p
token_posn(TokBoolOp p _) = p
token_posn(TokRelOp p _) = p
token_posn(TokIf p) = p
token_posn(TokThen p) = p
token_posn(TokElse p) = p
token_posn(TokFor p) = p
token_posn(TokMin p) = p
token_posn(TokMax p) = p
token_posn(TokRepeat p) = p
token_posn(TokWhile p) = p
token_posn(TokDo p) = p
token_posn(TokDef p) = p
token_posn(TokArrow p) = p
token_posn(TokReturn p) = p
token_posn(TokScan p) = p
token_posn(TokPrint p) = p
token_posn(TokPrintln p) = p
token_posn(TokString p _) = p
token_posn(TokVar p _) = p

fromFile::FilePath -> IO()
fromFile filename = do
    putStrLn ("\n<<Tokenizing " ++ filename  ++ ">>\n")
    handle <- openFile (filename) ReadMode
    s <- hGetContents handle
    let toks = alexScanTokens s
    mapM_ print toks

main::IO ()
main = do
    let s = ""
    args <- getArgs
    if length args == 0
        then do
            s <- getContents
            let toks = alexScanTokens s
            mapM_ print toks
        else do
            mapM_ fromFile args
}