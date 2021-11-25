while true
  do
    RESULT=$(curl -Is "$1" | head -n 1)
    if [[ "$RESULT" =~ "200" ]]; then
      echo "It's there!"
      say "Finished"
      break
    else
      echo "It's not there yet"
    fi
    sleep 5
  done
echo $RESULT

