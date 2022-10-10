RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# Script design for https://www.ateliers-marinette.fr/ URLs

last_checkup="NO_DATA"
last_checkup=$(stat -c '%x' last_checkup.toto  | awk -F"." ' { print $1 }')
echo "Derniere vérification des dispos : " $last_checkup
generated_files_location="curled_files/"
mkdir $generated_files_location

if test `find last_checkup.toto -mmin +30 ` 2>/dev/null || [[ ! -f last_checkup.toto ]]
    then
        run_state="true"

    else
        run_state="false"
fi


# OK
function  ateliers_marinette ()  {

    filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $6 }')
    website=$(echo $url | awk -F"/" '{ print $1"/"$2"/"$3}' )
    curl -s $url > $generated_files_location$filename
    grep -q "disabled>" $generated_files_location$filename
    if [[ $? != 0 ]]
        then
            echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
            echo $website","$filename",disponible" >> recap.csv
        else
            echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            echo $website","$filename",indisponible" >> recap.csv
    fi      

}

# OK
function  retrocamera ()  {

    filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $6 }')
    website=$(echo $url | awk -F"/" '{ print $1"/"$2"/"$3}')
    curl -s $url > $generated_files_location$filename
    grep -q "Ce produit est épuisé" $generated_files_location$filename
    if [[ $? != 0 ]]
        then
            echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
            echo $website","$filename",disponible" >> recap.csv
        else
            echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            echo $website","$filename",indisponible" >> recap.csv
    fi      

}

# # NOK // marche pas car il y a un script en frontal
function  nationphoto ()  {

    for url in $(< list_of_urls)
        do
            filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $6 }')
            website=$()
            curl -s $url > $generated_files_location$filename
            grep -q "disabled>" $generated_files_location$filename
            if [[ $? != 0 ]]
                then
                    echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
                    echo $website","$filename",disponible" >> recap.csv
                else
                    echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
                    echo $website","$filename",indisponible" >> recap.csv
            fi      
    done

}

# OK
function  fotoimpex ()  {

    filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $5 }')
    website=$(echo $url | awk -F"/" '{ print $1"/"$2"/"$3}')
    curl -s $url > $generated_files_location$filename
    grep -q "alt=\"Out of stock\"" $generated_files_location$filename
    if [[ $? != 0 ]]
        then
            grep -q "alt=\"Currently sold out\"" $generated_files_location$filename
            if [[ $? != 0 ]]
            then
                echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
                echo $website","$filename",disponible" >> recap.csv
            else
                echo -e $filename "est ${RED}\"Currently sold out\"${NC}" >> recap.txt
                echo $website","$filename",indisponible" >> recap.csv
            fi
        else
            reappro_date=$(grep "class=\"os_list_shipt7\">Expected" $generated_files_location$filename | sed 's|<span class="os_list_shipt7">||g' | awk -F"<" '{sub(/^[ \t]+/, ""); print $1}')
            echo -e $filename "est ${RED}\"Out of stock : ${reappro_date:="No expected date for back approx."} \"${NC}" >> recap.txt
            echo $website","$filename",indisponible,"$reappro_date >> recap.csv
    fi      

}

# OK
function  kamerastore ()  {

    filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $5 }')
    website=$(echo $url | awk -F"/" '{ print $1"/"$2"/"$3}')
    curl -s $url > $generated_files_location$filename
    check_soldout=$(grep -A1 "disabled" $generated_files_location$filename | grep -i sold )
    if [[ -z $check_soldout ]]
        then
            echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
            echo $website","$filename",disponible" >> recap.csv
        else
            echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            echo $website","$filename",indisponible" >> recap.csv
    fi      

}

# OK
function  digit_photo ()  {

    filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $4 }')
    website=$(echo $url | awk -F"/" '{ print $1"/"$2"/"$3}')
    curl -s $url > $generated_files_location$filename
    check_soldout=$(grep "id='title'>En réappro"  $generated_files_location$filename )
    if [[ -z $check_soldout ]]
        then
            echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
            echo $website","$filename",disponible" >> recap.csv
        else
            echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            echo $website","$filename",indisponible" >> recap.csv
    fi      

}

# OK
function  morifilmlab ()  {

    filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $7 }')
    website=$(echo $url | awk -F"/" '{ print $1"/"$2"/"$3}')
    curl -s $url > $generated_files_location$filename
    check_soldout=$(grep 'data-label="Epuisé<br>"'  $generated_files_location$filename )
    if [[ -z $check_soldout ]]
        then
            echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
            echo $website","$filename",disponible" >> recap.csv
        else
            echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            echo $website","$filename",indisponible" >> recap.csv
    fi      

}

# OK
function  buymorefilm ()  {

    filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $7 }')
    website=$(echo $url | awk -F"/" '{ print $1"/"$2"/"$3}')
    curl -s $url > $generated_files_location$filename
    check_soldout=$(grep -c "Sold Out"  $generated_files_location$filename )
    if [[ check_soldout -eq 2 ]]
        then
            echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
            echo $website","$filename",disponible" >> recap.csv
        else
            echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            echo $website","$filename",indisponible" >> recap.csv
    fi

}

# OK
function  filmphotographystore ()  {

    filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $7 }')
    website=$(echo $url | awk -F"/" '{ print $1"/"$2"/"$3}')
    curl -s $url > $generated_files_location$filename
    check_soldout=$(grep  "Sold Out"  $generated_files_location$filename )
    if [[ -z $check_soldout ]]
        then
            echo -e $filename "est ${GREEN}disponible${NC}" >> recap.txt
            echo $website","$filename",disponible" >> recap.csv
        else
            echo -e $filename "est ${RED}indisponible${NC}" >> recap.txt
            echo $website","$filename",indisponible" >> recap.csv
    fi

}

function  generate_price_check ()  {

    for url in $(< list_of_urls)
        do
            if [[ $url == *"ateliers-marinette"* ]]; then ateliers_marinette; fi
            if [[ $url == *"retrocamera"* ]]; then retrocamera; fi
            if [[ $url == *"fotoimpex"* ]]; then  fotoimpex; fi            
            if [[ $url == *"kamerastore"* ]]; then  kamerastore; fi
            if [[ $url == *"nationphoto"* ]]; then  nationphoto; fi                        
            if [[ $url == *"digit-photo"* ]]; then digit_photo; fi                        
            if [[ $url == *"morifilmlab"* ]]; then morifilmlab; fi                        
            if [[ $url == *"filmphotographystore"* ]]; then filmphotographystore; fi                        
            if [[ $url == *"buymorefilm"* ]]; then buymorefilm; fi                        
    done

}


function display_price_check () {

cat recap.txt

}



generate_price_check
display_price_check