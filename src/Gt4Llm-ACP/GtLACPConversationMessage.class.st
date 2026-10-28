"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPConversationMessage,
	#superclass : #GtLACPObject,
	#instVars : [
		'role',
		'messageId',
		'content'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #accessing }
GtLACPConversationMessage >> content [
 ^ content
]

{ #category : #accessing }
GtLACPConversationMessage >> content: anObject [
 content := anObject
]

{ #category : #views }
GtLACPConversationMessage >> gtContentFor: aView [
 <gtView>
 ^ aView list title: 'Content blocks'; priority: 20; items: [ content copy ]; itemText: #yourself; actionUpdateButtonTooltip: 'Refresh content blocks'
]

{ #category : #views }
GtLACPConversationMessage >> gtTextFor: aView [
 <gtView>
 ^ aView textEditor title: 'Text'; priority: 20; text: [ self text ]; actionUpdateButtonTooltip: 'Refresh text'
]

{ #category : #accessing }
GtLACPConversationMessage >> initialize [
 super initialize.
 content := OrderedCollection new
]

{ #category : #accessing }
GtLACPConversationMessage >> messageId [
 ^ messageId
]

{ #category : #accessing }
GtLACPConversationMessage >> messageId: anObject [
 messageId := anObject
]

{ #category : #accessing }
GtLACPConversationMessage >> printOn: aStream [
 aStream nextPutAll: role asString; nextPutAll: ': '; nextPutAll: self text
]

{ #category : #accessing }
GtLACPConversationMessage >> role [
 ^ role
]

{ #category : #accessing }
GtLACPConversationMessage >> role: anObject [
 role := anObject
]

{ #category : #accessing }
GtLACPConversationMessage >> text [
 ^ String streamContents: [ :stream | content do: [ :each | stream nextPutAll: each text ] ]
]
