Class {
	#name : #GtLlmExampleViewConversationCollector,
	#superclass : #Object,
	#instVars : [
		'example',
		'instructions'
	],
	#category : #'Gt4Llm-Fine Tuning'
}

{ #category : #accessing }
GtLlmExampleViewConversationCollector >> conversations [
	^ (Pragma allNamed: #gtView in: self instance class)
		collect: [ :aPragma | self toConversation: aPragma method ]
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
		withAll: {GtLlmSystemMessage new content: self instructions.
				GtLlmUserMessage new
					content: 'The context of this conversation is '
							, (GtLlmInspectorSummarizer new summarizeWithoutViews: self instance)
									summaryString , String cr , String cr
							, 'Please provide me with a potentially useful Phlow view method for the object instance. Strictly adhere to the Phlow API you know.'.
				GtLlmAssistantMessage new
					content: '```smalltaslk-method
' , self instance class asString
							, '
' , aView sourceCode
							, '
```'}
]
