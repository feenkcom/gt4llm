"
I am a target for GtLACPSession actions appearing in the hamburger menu of the ACP chat tool header. I am modeled after GtCoderClassTarget and LePageActionTarget.

To add an action to that menu, define it on GtLACPSession as a <gtAction> with me as a `target:`, or `addTarget:` me to keep it in its original place as well. See GtLACPSession>>#gtCloseFor:.
"
Class {
	#name : #GtLACPSessionActionTarget,
	#superclass : #GtPhlowActionUniqueTarget,
	#category : #'Gt4Llm-ACP-UI'
}
