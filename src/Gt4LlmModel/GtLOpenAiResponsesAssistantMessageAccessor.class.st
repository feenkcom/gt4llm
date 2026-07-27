Class {
	#name : #GtLOpenAiResponsesAssistantMessageAccessor,
	#superclass : #GtLModelAssistantMessageAccessor,
	#category : #'Gt4LlmModel-MessageAccessors'
}

{ #category : #accessing }
GtLOpenAiResponsesAssistantMessageAccessor >> content [

	^ self output 
		select: [ :each | each includesKey: 'content' ]
		thenCollect: [ :each | each at: 'content' ]
]

{ #category : #accessing }
GtLOpenAiResponsesAssistantMessageAccessor >> contentText [

	^ '' join: (self content flatCollect: [ :anArray |
		anArray
			select: [ :each | (each at: 'type') = 'output_text' ]
			thenCollect: [ :each | each at: 'text' ] ])
]

{ #category : #accessing }
GtLOpenAiResponsesAssistantMessageAccessor >> output [

	^ self rawData at: 'output'
]

{ #category : #accessing }
GtLOpenAiResponsesAssistantMessageAccessor >> reasoning [

	^ '' join: ((self output
		select: [ :jsonDict |
			jsonDict includesKey: 'summary' ])
		flatCollect: [ :jsonDict |
			(jsonDict at: 'summary') collect: 
				[ :jsonObject |
					jsonObject at: 'text' ] ])
]

{ #category : #accessing }
GtLOpenAiResponsesAssistantMessageAccessor >> role [

	^ self message at: 'role'
]
