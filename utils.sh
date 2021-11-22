waitForApp() {
    SELECTOR=$1
    REPLICAS=$2
    CONTAINERS="1/1"
    if [ $# == 3 ]
    then
        CONTAINERS="$3/$3"
    fi

    count=0
    echo -n "Waiting for $SELECTOR to be provisioned."
    while [ "$(oc get pods -l $SELECTOR -n $NAMESPACE --no-headers=true --ignore-not-found=true | grep Running | grep "$CONTAINERS" | wc -l)" -lt $REPLICAS ]
    do
        sleep 2
        echo -n "."
        (( count = count + 1 ))
        if [ $count -gt 150 ]
        then
            echo " failed."
            echo "$SELECTOR didn't come up after 300 seconds. Attempting to dump diagnostics..."
            # The "|| :" means "or noop", it ensures that the script doesn't exit due to the previous command failing
            # First, try login as system admin, in case we're on minishift, this is particularly useful on CI
            echo "" | oc login -u system:admin || :
            # Now, attempt to dump all node information
            oc describe nodes || :
            # Dump the events
            oc get events || :
            # Find any nodes that are in error, and output their logs
            for pod in $(oc get pods --no-headers | grep -v Running | cut -f1 -d" ")
            do
                echo Logs for $pod:
                oc logs --all-containers $pod || :
            done
            exit 1
        fi
    done

    echo " done."
}
