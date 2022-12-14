RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

# Script design for https://www.ateliers-marinette.fr/ URLs

# last_checkup="NO_DATA"
# last_checkup=$(stat -c '%x' last_checkup.toto  | awk -F"." ' { print $1 }')
# echo "Derniere vérification des dispos : " $last_checkup
generated_files_location="/home/gitlab/zatax_tracker/curled_files/"
mkdir $generated_files_location

# OK
function  ateliers_marinette ()  {

    filename=$(echo $url | awk -F'/' '{ gsub(".html","") } { print $6 }')
    website=$(echo $url | awk -F"/" '{ print $1"/"$2"/"$3}' )
    curl -s $url > $generated_files_location$filename
    grep -q "disabled>" $generated_files_location$filename
    if [[ $? != 0 ]]
        then
            if [[ "$counter_one" -lt 1 ]]; then counter_one=$((counter_one+1)); echo "  ateliersmarinette:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml            
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"OK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
        else
            if [[ "$counter_one" -lt 1 ]]; then counter_one=$((counter_one+1)); echo "  ateliersmarinette:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml               
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"NOK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
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
            if [[ "$counter_two" -lt 1 ]]; then counter_two=$((counter_two+1)); echo "  retrocamera:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml            
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"OK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
        else
            if [[ "$counter_two" -lt 1 ]]; then counter_two=$((counter_two+1)); echo "  retrocamera:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml               
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"NOK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
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
            if [[ "$counter_three" -lt 1 ]]; then counter_three=$((counter_three+1)); echo "  fotoimpex:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml            
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"OK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
            else
            if [[ "$counter_three" -lt 1 ]]; then counter_three=$((counter_three+1)); echo "  fotoimpex:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml               
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"NOK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
            fi
        else
            reappro_date=$(grep "class=\"os_list_shipt7\">Expected" $generated_files_location$filename | sed 's|<span class="os_list_shipt7">||g' | awk -F"<" '{sub(/^[ \t]+/, ""); print $1}')
            # echo -e $filename "est ${RED}\"Out of stock : ${reappro_date:="No expected date for back approx."} \"${NC}" >> recap.txt
            # echo $website","$filename",indisponible,"$reappro_date >> recap.csv
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
            if [[ "$counter_four" -lt 1 ]]; then counter_four=$((counter_four+1)); echo "  kamerastore:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml            
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"OK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
        else
            if [[ "$counter_four" -lt 1 ]]; then counter_four=$((counter_four+1)); echo "  kamerastore:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml               
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"NOK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
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
            if [[ "$counter_five" -lt 1 ]]; then counter_five=$((counter_five+1)); echo "  digit_photo:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml            
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"OK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
        else
            if [[ "$counter_five" -lt 1 ]]; then counter_five=$((counter_five+1)); echo "  digit_photo:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml               
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"NOK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
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
            if [[ "$counter_six" -lt 1 ]]; then counter_six=$((counter_six+1)); echo "  morifilmlab:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml            
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"OK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
        else
            if [[ "$counter_six" -lt 1 ]]; then counter_six=$((counter_six+1)); echo "  morifilmlab:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml               
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"NOK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
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
            if [[ "$counter_seven" -lt 1 ]]; then counter_seven=$((counter_seven+1)); echo "  buymorefilm:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml            
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"OK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
        else
            if [[ "$counter_seven" -lt 1 ]]; then counter_seven=$((counter_seven+1)); echo "  buymorefilm:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml               
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"NOK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
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
            if [[ "$counter_eight" -lt 1 ]]; then counter_eight=$((counter_eight+1)); echo "  filmphotographystore:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml            
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"OK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
        else
            if [[ "$counter_eight" -lt 1 ]]; then counter_eight=$((counter_eight+1)); echo "  filmphotographystore:" >> result.yaml; fi 
            echo "    $filename:" >> result.yaml               
            echo "      name: \"$filename\"" >> result.yaml
            echo "      disponiblity: \"NOK\"" >> result.yaml
            echo "      url: \"$url\"" >> result.yaml
    fi

}

function  generate_price_check ()  {

    echo "website:" >> result.yaml

    for url in $(< /home/gitlab/zatax_tracker/list_of_urls)
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

generate_price_check

ansible-playbook /home/gitlab/zatax_tracker/ansible/main.yml
