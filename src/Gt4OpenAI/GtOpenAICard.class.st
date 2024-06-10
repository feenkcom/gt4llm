Class {
	#name : #GtOpenAICard,
	#superclass : #Object,
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAICard >> codeDirectoryDescription [
	<magritteDescription>
	^ MADirectoryDescription new
		label: 'OpenAI API key file';
		priority: 4;
		labelAptitude: [ BrGlamorousLabelAptitude new glamorousFormLabelStyle ];
		editorAptitude: [ BrGlamorousLabelAptitude new glamorousFormEditorCodeFontAndSize ];
		kind: AbstractFileReference;
		display: #pathString;
		accessor: (MAPluggableAccessor
				read: [ :aModel |  GtOpenAIClient apiKeyFile ]
				write: [ :aModel :aValue | 
					 ])
]
