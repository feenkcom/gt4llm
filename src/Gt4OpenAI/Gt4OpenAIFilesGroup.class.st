Class {
	#name : #Gt4OpenAIFilesGroup,
	#superclass : #Gt4OpenAIGroup,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIFilesGroup >> gtFilesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Files';
		priority: 1;
		items: [self items];
		column: 'ID' text: #id;
		column: 'Filename' text: #filename;
		column: 'Size' text: #bytes weight: 0.5;
		column: 'Created at' text: #createdAt weight: 0.5;
		column: 'Purpose' text: #purpose weight: 0.5;
		column: 'Status' text: #status weight: 0.5
]
