Class {
	#name : #GtLlmExampleViewConversationCollector,
	#superclass : #Object,
	#instVars : [
		'example',
		'instructions',
		'viewsBlacklist'
	],
	#category : #'Gt4Llm-Fine Tuning'
}

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> blacklistedMethod: aMethod [
	self viewsBlacklist
		do: [ :aViewType | 
			| expr |
			expr := RBParser parseRewriteExpression: 'aView ' , aViewType.
			aMethod ast
				nodesDo: [ :each | (expr match: each inContext: Dictionary new) ifTrue: [ ^ true ] ] ].
	^ false
]

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> conversations [
	^ (Pragma allNamed: #gtView in: self instance class)
		reject: [ :aPragma | self blacklistedMethod: aPragma method ]
		thenCollect: [ :aPragma | self toConversation: aPragma method ]
]

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> defaultViewsBlacklist [
	^ {'mondrian'.
		'explicit'.
		'forward'}
]

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> example [
	^ example
]

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> example: anObject [
	example := anObject
]

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> initialize [
	super initialize.
	
	self viewsBlacklist: self defaultViewsBlacklist
]

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> instance [
	^ self example result returnValue
]

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> instructions [
	^ instructions
]

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> instructions: anObject [
	instructions := anObject
]

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> toConversation: aView [
	^ GtLlmMessagesGroup
		withAll: {GtLlmSystemMessage new content: self instructions instructionString.
				GtLlmUserMessage new
					content: 'The context of this conversation is '
							, (GtLlmInspectorSummarizer new summarizeWithoutViews: self instance)
									summaryString , String cr , String cr
							, 'Please provide me with a potentially useful Phlow view method for the object instance. Strictly adhere to the Phlow API you know.'.
				GtLlmAssistantMessage new
					content: '```smalltalk-method
' , self instance class asString
							, '
' , aView sourceCode
							, '
```'}
]

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> viewsBlacklist [
	^ viewsBlacklist
]

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> viewsBlacklist: anObject [
	viewsBlacklist := anObject
]
