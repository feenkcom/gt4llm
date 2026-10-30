"
A historical tool output. Preserves the OpenAI Responses wire payload without pretending to restore the original live object.
"
Class {
	#name : #GtLRecordedToolOutput,
	#superclass : #GtLWrappedModel,
	#category : #'Gt4Llm-DataSource-Model'
}

{ #category : #printing }
GtLRecordedToolOutput >> addContentOneLineSummaryTo: aStream [
	aStream nextPutAll: self model printString
]

{ #category : #views }
GtLRecordedToolOutput >> gtRecordedOutputFor: aView [
	"Inspect the historical wire payload, not an unavailable live result object."
	<gtView>
	^ aView textEditor
		title: 'Recorded output';
		priority: 1;
		aptitude: [ BrGlamorousCodeEditorAptitude ];
		styler: [ JSONParser gtStyler ];
		actionButtonIcon: BrGlamorousVectorIcons tree 
			tooltip: 'Inspect parsed JSON'
			action: [ :aButton | 
				aButton phlow spawnObject: (
					STONJSON fromString: self contents) ];
		text: [ STONJSON toStringPretty: self model ]
]

{ #category : #serialization }
GtLRecordedToolOutput >> serializeToOllamaOpenAiResponseOutput [
	^ self model
]

{ #category : #serialization }
GtLRecordedToolOutput >> serializeToOpenAIResponseOutput [
	^ self model
]
