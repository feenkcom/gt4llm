Extension { #name : #GtLlmFunctionTool }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmFunctionTool >> gtFunctionFor: aView [
	<gtView>
	^ aView textEditor
		title: 'JSON';
		priority: 20;
		text: [ STONJSON toStringPretty: self function ];
		styler: JSONParser gtStyler;
		aptitude: BrGlamorousCodeEditorAptitude;
		actionDropdownButtonLabel: 'Format'
			content: [ :aDropdown :tab | 
				BrSimpleList new fitContent
					items: {'Default' -> [ self function ].
							'Anthropic' -> [ self functionAnthropic ].
							'Gemini' -> [ self functionGemini ]};
					stencil: [ :pair | 
						BrLabel new
							aptitude: BrGlamorousLabelAptitude;
							text: pair key;
							when: BlClickEvent
								do: [ | query |
									query := tab viewContentElement query // BrEditor.
									query anyOne text: (STONJSON toStringPretty: pair value value) ] ] ]
]
