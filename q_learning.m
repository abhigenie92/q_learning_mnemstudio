% initialisation
clear all;
q=zeros(6,6);
reward=[-1 -1 -1 -1 0 -1;
        -1 -1 -1  0 -1 100;
        -1 -1 -1  0 -1 -1;
        -1  0  0 -1  0 -1;
         0 -1 -1  0 -1 100;
        -1  0 -1 -1  0 100];
gamma=0.8;
convergence_vec=zeros(1,num_games);

% play games
num_games=4000;
for ii=1:num_games,
    q_changed=[];
    initial_state=randi([1 6]);
    curr_state=initial_state;
    % do while the goal state hasn't been reached.
    flag=1;
    while curr_state~=6 | flag,
        % select one among all possible actions for the current state.
        possible_actions=find(reward(curr_state,:)~=-1);
        rand_int=randi([1 numel(possible_actions)]);
        action=possible_actions(rand_int);
        
        % using this possible action, consider going to the next state.
        if q(curr_state,action) ~=1, % legal action condition
            % Get maximum Q value for this next state based on all possible actions.
            max_q=max(q(action,:));
   
            initial_q=q(curr_state,action);
            
            q(curr_state,action)=reward(curr_state,action)+gamma*max_q;
           
            % store the change in q
            q_changed=[q_changed abs(initial_q-q(curr_state,action))];
            
            % set the next state as the current state.
            curr_state=action;         
        end
        flag=0;
    end
    convergence_vec(ii)=norm(q_changed);
end

% plot convergence
bar(convergence_vec);
xlabel('Game Played');
ylabel('Change in q');
