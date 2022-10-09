RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# Script design for https://www.ateliers-marinette.fr/ URLs

last_checkup="NO_DATA"
last_checkup=$(stat -c '%x' last_checkup.toto  | awk -F"." ' { print $1 }')
echo "Derniere vérification des dispos : " $last_checkup
generated_files_location="curled_files/"

if test `find last_checkup.toto -mmin +30 ` 2>/dev/null || [[ ! -f last_checkup.toto ]]
    then
        run_state="true"

    else
        run_state="false"
fi


# OK
function  ateliers_marinette ()  {

    for url in $(< list_of_urls)
        do
            filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $6 }')
            website=$()
            curl -s $url > $filename
            grep -q "disabled>" $filename
            if [[ $? != 0 ]]
                then
                    echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
                else
                    echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            fi      
    done

}

# OK
function  retrocamera ()  {

    for url in $(< list_of_urls)
        do
            filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $6 }')
            website=$()
            curl -s $url > $filename
            grep -q "Ce produit est épuisé" $filename
            if [[ $? != 0 ]]
                then
                    echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
                else
                    echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            fi      
    done

}

# Nationphoto marche pas car il y a un script en frontal
function  nationphoto ()  {

    for url in $(< list_of_urls)
        do
            filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $6 }')
            website=$()
            curl -s $url > $filename
            grep -q "disabled>" $filename
            if [[ $? != 0 ]]
                then
                    echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
                else
                    echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            fi      
    done

}

# OK
function  fotoimpex ()  {

    for url in $(< list_of_urls)
        do
            filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $5 }')
            website=$()
            curl -s $url > $filename
            grep -q "alt=\"Out of stock\"" $filename
            if [[ $? != 0 ]]
                then
                    grep -q "alt=\"Currently sold out\"" $filename
                    if [[ $? != 0 ]]
                    then
                        echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
                    else
                        echo -e $filename "est ${RED}\"Currently sold out\"${NC}" >> recap.txt
                    fi
                else
                    reappro_date=$(grep "class=\"os_list_shipt7\">Expected" $filename | sed 's|<span class="os_list_shipt7">||g' | awk -F"<" '{sub(/^[ \t]+/, ""); print $1}')
                    echo -e $filename "est ${RED}\"Out of stock : ${reappro_date:="No expected date for back approx."} \"${NC}" >> recap.txt
            fi      
    done

}

# OK
function  kamerastore ()  {

    for url in $(< list_of_urls)
        do
            filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $5 }')
            website=$()
            curl -s $url > $filename
            check_soldout=$(grep -A1 "disabled" $filename | grep -i sold )
            if [[ -z $check_soldout ]]
                then
                    echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
                else
                    echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            fi      
    done

}

# OK
function  digit_photo ()  {

    for url in $(< list_of_urls)
        do
            filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $4 }')
            website=$()
            curl -s $url > $filename
            check_soldout=$(grep "id='title'>En réappro"  $filename )
            if [[ -z $check_soldout ]]
                then
                    echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
                else
                    echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            fi      
    done

}

function  morifilmlab ()  {

    for url in $(< list_of_urls)
        do
            filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $7 }')
            website=$()
            curl -s $url > $filename
            check_soldout=$(grep 'data-label="Epuisé<br>"'  $filename )
            if [[ -z $check_soldout ]]
                then
                    echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
                else
                    echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            fi      
    done

}

function  buymorefilm ()  {

    for url in $(< list_of_urls)
        do
            filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $7 }')
            website=$()
            curl -s $url > $filename
            check_soldout=$(grep -c "Sold Out"  $filename )
            if [[ check_soldout -eq 2 ]]
                then
                    echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
                else
                    echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            fi      
    done

}

function  filmphotographystore ()  {

    for url in $(< list_of_urls)
        do
            filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $7 }')
            website=$()
            curl -s $url > $filename
            check_soldout=$(grep  "Sold Out"  $filename )
            if [[ -z $check_soldout ]]
                then
                    echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
                else
                    echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            fi      
    done

}

function  generate_price_check ()  {

# ateliers_marinette
# retrocamera
# nationphoto
# fotoimpex
# kamerastore
# digit_photo
# morifilmlab
# buymorefilm
filmphotographystore

}


function display_price_check () {

cat recap.txt

}



## MAIN PROGRAM

# if [ $run_state = "true" ]
#     then
#         generate_price_check
#         display_price_check
#         touch last_checkup.toto
#     else
#         display_price_check
# fi


generate_price_check
display_price_check