---
name: Bug report
about: Unexpected program behaviour that needs code correction
title: ''
labels: Bug, Evaluation
assignees: ''

---

<!--
I fully read and understood contributing guidelines of ASF available under https://github.com/JustArchiNET/ArchiSteamFarm/blob/master/.github/CONTRIBUTING.md and I believe that my issue is valid - it requires a response from ASF development team, and not ASF support.

I UNDERSTAND THAT IF MY ISSUE IS NOT MEETING CONTRIBUTING GUIDELINES SPECIFIED ABOVE, ESPECIALLY IF IT'S A QUESTION OR TECHNICAL ISSUE THAT IS NOT RELATED TO ASF DEVELOPMENT IN ANY WAY, THEN IT WILL BE CLOSED AND LEFT UNANSWERED.

Feel free to remove our notice and fill the template below with your details.
-->

## Bug report

### Description

<!-- Short explanation of what you were going to do, what did you want to accomplish? -->

### Expected behavior

<!-- What did you expect to happen? -->

### Current behavior

<!-- What happened instead? -->

### Possible solution

<!-- Not mandatory, but you can suggest a fix/reason for the bug, if known to you. -->

### Steps to reproduce

<!-- Every command or action that happened after launching ASF, which leads to the bug. -->
<!-- If launching ASF with provided configs (below) is everything that is needed, then this section is not mandatory. -->

### Full log.txt recorded during reproducing the problem

```text
Paste here, in-between triple backtick tags

Ensure that your log is complete and was NOT recorded in Debug mode, as debug log may contain sensitive information that should not be shared publicly, as per our wiki statement. Standard ASF log does not include sensitive information.
```

### Global ASF.json config (if using one)

```json
Paste here, in-between triple backtick tags

Ensure that your config has redacted (but NOT removed) potentially-sensitive properties, such as:
- IPCPassword (recommended)
- SteamOwnerID (optionally)
- WebProxy (optionally, if exposing private details)
- WebProxyPassword (optionally, if exposing private details)
- WebProxyUsername (optionally, if exposing private details)

Redacting involves replacing sensitive details, for example with stars (***). You should refrain from removing config lines entirely, as their pure existence may be relevant and should be preserved.
```

### BotName.json config of all affected bot instances (if more than one)

```json
Paste here, in-between triple backtick tags

Ensure that your config has redacted (but NOT removed) potentially-sensitive properties, such as:
- SteamLogin (mandatory)
- SteamPassword (mandatory)
- SteamMasterClanID (optionally)
- SteamParentalCode (optionally)
- SteamTradeToken (optionally)
- SteamUserPermissions (optionally, only SteamIDs)

Redacting involves replacing sensitive details, for example with stars (***). You should refrain from removing config lines entirely, as their pure existence may be relevant and should be preserved.
```

### Additional info

<!-- Everything else you consider worthy that we didn't ask for. -->
