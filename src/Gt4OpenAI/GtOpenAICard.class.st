Class {
	#name : #GtOpenAICard,
	#superclass : #Object,
	#category : #Gt4OpenAI
}

{ #category : #accessing }
GtOpenAICard >> codeDirectoryDescription [
	<magritteDescription>
	^ MAFileDescription new
		label: 'OpenAI API key file';
		priority: 4;
		labelAptitude: [ BrGlamorousLabelAptitude new glamorousFormLabelStyle ];
		editorAptitude: [ BrGlamorousLabelAptitude new glamorousFormEditorCodeFontAndSize ];
		kind: AbstractFileReference;
		display: #pathString;
		accessor: (MAPluggableAccessor
				read: [ :aModel | GtOpenAIClient apiKeyFile ]
				write: [ :aModel :aValue | GtOpenAIClient apiKeyFile: aValue ]);
		addCondition: [ :aFileReference | aFileReference asFileReference exists ]
]

{ #category : #accessing }
GtOpenAICard >> magrittePingAction [
	<magritteActionDescription>
	^ MAActionDescription new
		priority: 20;
		label: 'Try';
		blocIcon: BrGlamorousVectorIcons play;
		action: [ :aModel :aButton :aMemento :aDescription | 
			[ GtOpenAIClient withApiKeyFromFile listModels.
			aButton
				icon: BrGlamorousVectorIcons accept;
				label: 'Success!';
				disable ]
				on: Error
				do: [ aButton
						icon: BrGlamorousVectorIcons cancel;
						label: 'Authentication error';
						disable ] ];
		beEnabledOnValidOverallStatus;
		beToolbarAction
]
