---
layout: single
sitemap: true
title: "Applying MITRE ATT&CK for ICS on Oldsmar cyberattack"
categories:
  - Blog
tags:
  - ICS
  - OT
  - cyberattack
  - ATT&CK
  - Mitre
---



I have been learning MITRE ATT&CK for quite sometime, I have specifically explored attack for ICS (Industrial Control Systems). On 9th February 2021 a news came out that a malicious attacker tried to manipulate [Sodium Hydroxide](https://www.chemicalsafetyfacts.org/sodium-hydroxide/) (Lye) levels to 100x in the [water treatment facility in Oldsmar town](https://www.myoldsmar.com/160/Water-Division) near Tampa, Florida, USA.  The attack was carried out by gaining access to remote workstation using TeamViewer. Well how were the credentials stolen for the TeamViewer access is still under investigation. The operator quickly noticed the mouse cursor moving on his screen and changed the NaOH levels to normal value. The change was too less that the further alarms of the facility also didn't go off. 

Sodium Hydroxide is used to regulate pH scale of water and also to remove heavy metals from water. If it had went un-noticed it may have caused serious illness to humans drinking it or even fatal. The attacker didn't seem to be sophisticated in nature but the intention was definitely malicious.

I wanted to map all the techniques and tactics used during this cyberattack using ATT&CK framework for that sake we will be using [ATT&CK navigator](https://mitre-attack.github.io/attack-navigator/) 

## Oldsmar water treatment facility cyberattack

Let's put each tactic and its corresponding techniques under it.
![attack ics for oldsmar cyberattack](/assets/postimages/2/oldsmar_cyberattack_attack_mapping.svg)

### Initial Access 

 - Engineering workstation compromise: As, the workstation running inside the facility was accessed to manipulate NaOH values.
 - Exploiting Public facing Application: TeamViewer was unintentionally exposed to internet but still I have considered this.
 - External Remote Services: Through remote work software TeamViewer.  

### Execution 

- Graphical User Interface: As, attacker directly manipulated values with HMI dashboard from the workstation targeted.

### Persistence

- Valid accounts: Attacker used two valid TeamViewer accounts to gain persistence on workstation system.

### Impair Process Control 

- Modify Parameter: Values of Sodium Hydroxide were modified.
- Unauthorized command message: Attacker sent a command to increase the value of NaOH to more then normal levels. 

### Impact

- Loss of Safety: Safety of lives drinking the that water would have been lost.
- Manipulation of control: The chemical level control put in place was manipulated. 

Above are the tactics and its relevant techniques I believe were applicable. Some may or may not be applied based on interpretation and availability of information on the incident.   

## Mapping it to already known APT groups

We can map the TTP's of all known and tracked APT's provided by attack for ICS by adding another layer and providing gradient score to each layer in ATT&CK navigator. 

![common ttp's with APT groups for ICS](/assets/postimages/2/common_ttps.svg)

<span style="color:red">**Red**</span> are the Tactics from cyberattack which we mapped based on the available information. 
<span style="color:yellow">**Yellow**</span> are the tactics known to be used by various APT's for ICS in past.
<span style="color:green">**Green**</span> are the common tactics found between both layers. 

**External Remote Services** and **Valid accounts** are the common tactics which were used during this attack. Although there is no evidence of an APT being behind this attack but who knows what future investigations might reveal 🙃

Furthermore, for these tactics we can now  check which mitigations to apply in the navigator from the mitigations selection panel.

<p align="center">
<img src="/assets/postimages/2/mitigations_panel_mitre.png">
</p>

Some of the mitigations we can derive from it are.

 1. Account Use policies
 2. Application Isolation & Sandboxing
 3. Multi Factor Authentication
 4. Network Allow lists
 5. Password policies
 6. Network segregation between IT & OT networks
 7. Privileged account management
 
 Moreover with the new remote work way after the pandemic it is very important to have better visibility and access management on our networks. OT asset owners should not rely on IT tools in order to track activity inside their networks. 

Hope you enjoyed reading this. Happy Hacking !!

**References**

 - [https://collaborate.mitre.org/attackics/index.php/Main_Page](https://collaborate.mitre.org/attackics/index.php/Main_Page)
 - [https://www.youtube.com/watch?v=pcclNdwG8Vs](https://www.youtube.com/watch?v=pcclNdwG8Vs)
 - [https://www.nozominetworks.com/blog/hard-lessons-from-the-oldsmar-water-facility-cyberattack-hack/](https://www.nozominetworks.com/blog/hard-lessons-from-the-oldsmar-water-facility-cyberattack-hack/)
 - [https://www.dragos.com/blog/industry-news/recommendations-following-the-oldsmar-water-treatment-facility-cyber-attack/](https://www.dragos.com/blog/industry-news/recommendations-following-the-oldsmar-water-treatment-facility-cyber-attack/)
 - [https://www.reuters.com/article/us-usa-cyber-florida-idUSKBN2A82FV](https://www.reuters.com/article/us-usa-cyber-florida-idUSKBN2A82FV)
