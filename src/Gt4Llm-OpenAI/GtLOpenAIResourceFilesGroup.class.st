Class {
	#name : #GtLOpenAIResourceFilesGroup,
	#superclass : #GtLlmGroup,
	#category : #'Gt4Llm-OpenAI'
}

{ #category : #accessing }
GtLOpenAIResourceFilesGroup class >> leJsonV4Name [

	^ #gtOpenAIResourceFilesGroup
]

{ #category : #accessing }
GtLOpenAIResourceFilesGroup >> gtFilesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Files';
		priority: 1;
		items: [ self items ];
		column: 'File' text: #file;
		column: 'Remote ID' text: #remoteId;
		column: 'Description' text: #description
]

{ #category : #accessing }
GtLOpenAIResourceFilesGroup >> toFileDescriptions [
	^ 'Here is a description of the files you have access to:
	
'
		, ({Character lf.
				Character lf} join: (self items collect: #toFileDescription))
]
