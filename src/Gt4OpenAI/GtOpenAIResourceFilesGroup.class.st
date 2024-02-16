Class {
	#name : #GtOpenAIResourceFilesGroup,
	#superclass : #GtLlmGroup,
	#category : #'Gt4OpenAI-Groups'
}

{ #category : #accessing }
GtOpenAIResourceFilesGroup >> gtFilesFor: aView [
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
GtOpenAIResourceFilesGroup >> toFileDescriptions [
	^ 'Here is a description of the files you have access to:
	
'
		, ({Character lf.
				Character lf} join: (self items collect: #toFileDescription))
]
