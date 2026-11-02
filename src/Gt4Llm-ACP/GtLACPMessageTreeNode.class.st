"
I expose one protocol message with its role, presentation classification and compact text in the conversation tree.
"
Class {
	#name : #GtLACPMessageTreeNode,
	#superclass : #GtLACPConversationTreeNode,
	#category : #'Gt4Llm-ACP-UI'
}

{ #category : #accessing }
GtLACPMessageTreeNode >> kind [
 ^ { #user -> 'User'. #agent -> 'Assistant'. #thought -> 'Reasoning'. #session -> 'Agent message' }
  asDictionary at: object role ifAbsent: [ object role asString ]
]

{ #category : #accessing }
GtLACPMessageTreeNode >> label [
 | text |
 text := (object text copyReplaceAll: String cr with: ' ') copyReplaceAll: String lf with: ' '.
 ^ text size > 120 ifTrue: [ (text first: 119), '…' ] ifFalse: [ text ]
]

{ #category : #accessing }
GtLACPMessageTreeNode >> state [
 ^ turn ifNil: [ '' ] ifNotNil: [ turn presentationOf: object ]
]
