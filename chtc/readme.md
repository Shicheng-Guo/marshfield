## Submitting Multiple Jobs Using HTCondor

1.1  $(Process): from 0 to N-1. Set newid=$(Process)+1 and $INT(newid,%d)
1.2  queue from paramter files:   queue state from state_list.txt
1.3  queue state in (a.data, b.data, c.data)
1.4  queue year, state from states_year.list.txt  (year and state are listed in txt and separate with , )
1.5  initialdir=$(state), put the input in the different initial directory 


