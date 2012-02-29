Since the RepositoryCloner requires an ssh-agent, the following was
added to the bottom of the ubuntu user's .bashrc file on the server for
the deployment environments.

Via: [http://superuser.com/questions/141044/sharing-the-same-ssh-agent-among-multiple-login-sessions](http://superuser.com/questions/141044/sharing-the-same-ssh-agent-among-multiple-login-sessions)


```
SSH_ENV=$HOME/.ssh/environment

function start_agent {
  echo "Initialising new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > ${SSH_ENV}
  echo succeeded
  chmod 600 ${SSH_ENV}
  . ${SSH_ENV} > /dev/null
  /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
  . ${SSH_ENV} > /dev/null
  #ps ${SSH_AGENT_PID} doesn't work under cywgin
  ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi
```
