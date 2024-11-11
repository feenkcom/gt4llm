Class {
	#name : #GtOpenAILepiterWardleyMapSnippetTutor,
	#superclass : #GtOpenAILepiterSnippetTutor,
	#category : #'Gt4OpenAI-Tutor'
}

{ #category : #'as yet unclassified' }
GtOpenAILepiterWardleyMapSnippetTutor >> explanationAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Explain a node';
		priority: 3;
		description: 'Explains what a node means and why it is on the map using human language.';
		format: 'Explain the node `{1}`';
		examples: {}
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterWardleyMapSnippetTutor >> formatName [
	^ 'serialized Lepiter Wardley Map snippet'
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterWardleyMapSnippetTutor >> initialAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Create a set of nodes';
		priority: 1;
		description: 'Creates a set of at least 20 nodes based on a given topic, filling topic, nodes, and connections with sensible data. If a map topic was already set, it is overridden. The rest of the map is extended. Make sure to generate real UUIDs (randomly assigned) for the nodes of the format 32 lowercase hexadecimal (base 16) digits, displayed in five groups separated by hyphens, in the form 8-4-4-4-12 for a total of 36 characters (32 alphanumeric characters and four hyphens).';
		format: 'Create a set of nodes on {1}';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Create a set of nodes on Moldable development'.
							'Snippet'
								-> '{"__schema":"4.1","__type":"wardleyMap","children":{"__type":"snippets","items":[]},"createEmail":{"__type":"email","emailString":"veit.heller@feenk.com"},"createTime":{"__type":"time","time":{"__type":"dateAndTime","dateAndTimeString":"2024-11-08T12:38:21.816761+01:00"}},"editEmail":{"__type":"email","emailString":"veit.heller@feenk.com"},"editTime":{"__type":"time","time":{"__type":"dateAndTime","dateAndTimeString":"2024-11-08T12:38:21.816761+01:00"}},"uid":{"__type":"uid","uidString":"KNnR7MbiDQC+PEQxDuceSQ=="},"wardleyMapDictionary":{"edges":[],"nodes":[]},"snippetHeight":300}'}
							asDictionary;
					output: {'Action' -> 'Create a set of nodes'.
							'Text' -> nil.
							'Rename' -> nil.
							'Snippet'
								-> '{"__schema":"4.1","__type":"wardleyMap","children":{"__type":"snippets","items":[]},"createEmail":{"__type":"email","emailString":"veit.heller@feenk.com"},"createTime":{"__type":"time","time":{"__type":"dateAndTime","dateAndTimeString":"2024-11-08T12:38:21.816761+01:00"}},"editEmail":{"__type":"email","emailString":"veit.heller@feenk.com"},"editTime":{"__type":"time","time":{"__type":"dateAndTime","dateAndTimeString":"2024-11-08T12:18:45.213064+01:00"}},"uid":{"__type":"uid","uidString":"gQC8AMbiDQC1SgHEDuceSQ=="},"wardleyMapDictionary":{"edges":[{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"c39e25db-c6e2-0d00-be2b-02470ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"cb9e25db-c6e2-0d00-be2c-8fca0ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"c39e25db-c6e2-0d00-be2b-02470ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"ac9e25db-c6e2-0d00-be28-f73f0ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"c39e25db-c6e2-0d00-be2b-02470ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"779e25db-c6e2-0d00-be1f-690f0ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"8d9e25db-c6e2-0d00-be23-59ac0ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"ac9e25db-c6e2-0d00-be28-f73f0ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"779e25db-c6e2-0d00-be1f-690f0ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"029f25db-c6e2-0d00-be30-74ea0ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"029f25db-c6e2-0d00-be30-74ea0ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"b39e25db-c6e2-0d00-be29-67410ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"989e25db-c6e2-0d00-be25-970b0ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"009e25db-c6e2-0d00-be1e-42470ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"009e25db-c6e2-0d00-be1e-42470ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"899e25db-c6e2-0d00-be22-d4900ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"899e25db-c6e2-0d00-be22-d4900ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"819e25db-c6e2-0d00-be20-8de50ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"819e25db-c6e2-0d00-be20-8de50ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"859e25db-c6e2-0d00-be21-ed850ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"bb9e25db-c6e2-0d00-be2a-10f70ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"e49e25db-c6e2-0d00-be2d-511b0ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"e49e25db-c6e2-0d00-be2d-511b0ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"7c9d25db-c6e2-0d00-be1d-67a00ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"ee9e25db-c6e2-0d00-be2e-cb6a0ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"f89e25db-c6e2-0d00-be2f-b85f0ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"f89e25db-c6e2-0d00-be2f-b85f0ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"a59e25db-c6e2-0d00-be27-d2700ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"939e25db-c6e2-0d00-be24-44d70ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"bb9e25db-c6e2-0d00-be2a-10f70ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"9e9e25db-c6e2-0d00-be26-90550ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"b39e25db-c6e2-0d00-be29-67410ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"9e9e25db-c6e2-0d00-be26-90550ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"029f25db-c6e2-0d00-be30-74ea0ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"a59e25db-c6e2-0d00-be27-d2700ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"7c9d25db-c6e2-0d00-be1d-67a00ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"859e25db-c6e2-0d00-be21-ed850ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"8d9e25db-c6e2-0d00-be23-59ac0ee71e49"},"width":1.0},{"arrow":false,"color":{"alpha":1.0,"blue":0.5004887585532747,"green":0.5004887585532747,"red":0.5004887585532747},"from":{"__type":"uuid","uuid":"009e25db-c6e2-0d00-be1e-42470ee71e49"},"label":{"is_visible":false,"text":"Edge label","x":0.5,"y":0.5},"to":{"__type":"uuid","uuid":"029f25db-c6e2-0d00-be30-74ea0ee71e49"},"width":1.0}],"nodes":[{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"7c9d25db-c6e2-0d00-be1d-67a00ee71e49"},"label":{"text":"User-Centric Design","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.89,"y":0.52},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"009e25db-c6e2-0d00-be1e-42470ee71e49"},"label":{"text":"Continuous Integration","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.21,"y":0.19999999999999996},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"779e25db-c6e2-0d00-be1f-690f0ee71e49"},"label":{"text":"Integration APIs","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.79,"y":0.49},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"819e25db-c6e2-0d00-be20-8de50ee71e49"},"label":{"text":"Automated Testing","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.51,"y":0.27},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"859e25db-c6e2-0d00-be21-ed850ee71e49"},"label":{"text":"Feedback Systems","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.93,"y":0.42000000000000004},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"899e25db-c6e2-0d00-be22-d4900ee71e49"},"label":{"text":"Testing Frameworks","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.38,"y":0.28},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"8d9e25db-c6e2-0d00-be23-59ac0ee71e49"},"label":{"text":"User Interface","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.61,"y":0.42000000000000004},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"939e25db-c6e2-0d00-be24-44d70ee71e49"},"label":{"text":"End-User Programming","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.48,"y":0.56},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"989e25db-c6e2-0d00-be25-970b0ee71e49"},"label":{"text":"Agile Methodologies","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.2,"y":0.36},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"9e9e25db-c6e2-0d00-be26-90550ee71e49"},"label":{"text":"Security Layers","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.81,"y":0.4},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"a59e25db-c6e2-0d00-be27-d2700ee71e49"},"label":{"text":"Adaptive User Experience","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.72,"y":0.69},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"ac9e25db-c6e2-0d00-be28-f73f0ee71e49"},"label":{"text":"Customization Layer","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.5,"y":0.6},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"b39e25db-c6e2-0d00-be29-67410ee71e49"},"label":{"text":"Data Storage","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.8,"y":0.15000000000000002},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"bb9e25db-c6e2-0d00-be2a-10f70ee71e49"},"label":{"text":"Domain-Specific Languages","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.42,"y":0.65},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"c39e25db-c6e2-0d00-be2b-02470ee71e49"},"label":{"text":"Moldable Development","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.37,"y":0.6599999999999999},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"cb9e25db-c6e2-0d00-be2c-8fca0ee71e49"},"label":{"text":"Prototyping Tools","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.44,"y":0.79},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"e49e25db-c6e2-0d00-be2d-511b0ee71e49"},"label":{"text":"Domain Modeling","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.57,"y":0.45999999999999996},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"ee9e25db-c6e2-0d00-be2e-cb6a0ee71e49"},"label":{"text":"Component Libraries","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.42,"y":0.39},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"f89e25db-c6e2-0d00-be2f-b85f0ee71e49"},"label":{"text":"Visual Programming","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.65,"y":0.77},{"color":{"alpha":1.0,"blue":0.0,"green":0.0,"red":0.0},"evolve":{"is_visible":false},"height":12,"id":{"__type":"uuid","uuid":"029f25db-c6e2-0d00-be30-74ea0ee71e49"},"label":{"text":"Cloud Deployment","x":0.5,"y":2.0},"pipeline":{"is_visible":false},"width":12,"x":0.66,"y":0.030000000000000027}]},"snippetHeight":300}'}
							asDictionary.
				GtLlmTutorActionExample new
					input: {'Action'
								-> 'Create a set of nodes on Key components for a drone delivery service'.
							'Snippet'
								-> '{"__schema":"4.1","__type":"wardleyMap","children":{"__type":"snippets","items":[]},"createEmail":{"__type":"email","emailString":"veit.heller@feenk.com"},"createTime":{"__type":"time","time":{"__type":"dateAndTime","dateAndTimeString":"2024-11-08T12:38:21.816761+01:00"}},"editEmail":{"__type":"email","emailString":"veit.heller@feenk.com"},"editTime":{"__type":"time","time":{"__type":"dateAndTime","dateAndTimeString":"2024-11-08T12:38:21.816761+01:00"}},"uid":{"__type":"uid","uidString":"KNnR7MbiDQC+PEQxDuceSQ=="},"wardleyMapDictionary":{"edges":[],"nodes":[]},"snippetHeight":300}'}
							asDictionary;
					output: {'Action' -> 'Create a set of nodes'.
							'Text' -> nil.
							'Rename' -> nil.
							'Snippet'
								-> '{"__schema":"4.1","__type":"wardleyMap","children":{"__type":"snippets","items":[]},"createEmail":{"__type":"email","emailString":"veit.heller@feenk.com"},"createTime":{"__type":"time","time":{"__type":"dateAndTime","dateAndTimeString":"2024-11-08T12:38:21.816761+01:00"}},"editEmail":{"__type":"email","emailString":"veit.heller@feenk.com"},"editTime":{"__type":"time","time":{"__type":"dateAndTime","dateAndTimeString":"2024-11-08T12:18:45.213064+01:00"}},"uid":{"__type":"uid","uidString":"gQC8AMbiDQC1SgHEDuceSQ=="},"wardleyMapDictionary":{
	"nodes" : [
		{
			"id" : "35d42069-00e3-0d00-bf50-6e490ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.3,
			"y" : 0.30000000000000004,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Regulatory Compliance"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "87d42069-00e3-0d00-bf51-8e460ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.4,
			"y" : 0.7,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Maintenance Services"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "cbd42069-00e3-0d00-bf52-cdf80ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.7,
			"y" : 0.19999999999999996,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Data Analytics"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "dbd42069-00e3-0d00-bf53-58310ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.5,
			"y" : 0.7,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Ground Control"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "ded42069-00e3-0d00-bf54-12270ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.3,
			"y" : 0.5,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Security Protocols"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "e0d42069-00e3-0d00-bf55-dd270ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.9,
			"y" : 0.30000000000000004,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "User Feedback System"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "e3d42069-00e3-0d00-bf56-68850ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.9,
			"y" : 0.4,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Automated Scheduling"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "e6d42069-00e3-0d00-bf57-12bf0ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.4,
			"y" : 0.4,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Emergency Response System"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "e9d42069-00e3-0d00-bf58-f1fe0ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.6,
			"y" : 0.5,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Navigation System"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "ecd42069-00e3-0d00-bf59-74d70ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.7,
			"y" : 0.6,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Package Handling"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "efd42069-00e3-0d00-bf5a-0d640ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.3,
			"y" : 0.8,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Drone Manufacturing"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "f3d42069-00e3-0d00-bf5b-256a0ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.5,
			"y" : 0.19999999999999996,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Fleet Management Software"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "f7d42069-00e3-0d00-bf5c-6d050ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.8,
			"y" : 0.5,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Traffic Management"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "fbd42069-00e3-0d00-bf5d-92b20ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.8,
			"y" : 0.30000000000000004,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Customer Interface"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "00d52069-00e3-0d00-bf5e-fa460ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.3,
			"y" : 0.6,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Drone Fleet"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "05d52069-00e3-0d00-bf5f-0c590ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.6,
			"y" : 0.4,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Communication Network"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "12d52069-00e3-0d00-bf60-db8a0ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.6,
			"y" : 0.30000000000000004,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Mapping Services"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "17d52069-00e3-0d00-bf61-6d4b0ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.7,
			"y" : 0.4,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Delivery Software"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "1dd52069-00e3-0d00-bf62-619d0ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.4,
			"y" : 0.5,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Battery Management"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		},
		{
			"id" : "22d52069-00e3-0d00-bf63-8f5b0ee71e49",
			"color" : {
				"green" : 0.0,
				"blue" : 0.0,
				"alpha" : 1.0,
				"red" : 0.0
			},
			"x" : 0.5,
			"y" : 0.4,
			"width" : 12,
			"height" : 12,
			"label" : {
				"x" : 0.5,
				"y" : 2.0,
				"text" : "Weather Monitoring"
			},
			"pipeline" : {
				"is_visible" : false
			},
			"evolve" : {
				"is_visible" : false
			}
		}
	],
	"edges" : [
		{
			"from" : "00d52069-00e3-0d00-bf5e-fa460ee71e49",
			"to" : "e9d42069-00e3-0d00-bf58-f1fe0ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "00d52069-00e3-0d00-bf5e-fa460ee71e49",
			"to" : "1dd52069-00e3-0d00-bf62-619d0ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "e9d42069-00e3-0d00-bf58-f1fe0ee71e49",
			"to" : "dbd42069-00e3-0d00-bf53-58310ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "dbd42069-00e3-0d00-bf53-58310ee71e49",
			"to" : "f7d42069-00e3-0d00-bf5c-6d050ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "17d52069-00e3-0d00-bf61-6d4b0ee71e49",
			"to" : "fbd42069-00e3-0d00-bf5d-92b20ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "fbd42069-00e3-0d00-bf5d-92b20ee71e49",
			"to" : "e0d42069-00e3-0d00-bf55-dd270ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "ecd42069-00e3-0d00-bf59-74d70ee71e49",
			"to" : "00d52069-00e3-0d00-bf5e-fa460ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "1dd52069-00e3-0d00-bf62-619d0ee71e49",
			"to" : "e6d42069-00e3-0d00-bf57-12bf0ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "22d52069-00e3-0d00-bf63-8f5b0ee71e49",
			"to" : "e9d42069-00e3-0d00-bf58-f1fe0ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "f7d42069-00e3-0d00-bf5c-6d050ee71e49",
			"to" : "35d42069-00e3-0d00-bf50-6e490ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "35d42069-00e3-0d00-bf50-6e490ee71e49",
			"to" : "ded42069-00e3-0d00-bf54-12270ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "05d52069-00e3-0d00-bf5f-0c590ee71e49",
			"to" : "cbd42069-00e3-0d00-bf52-cdf80ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "cbd42069-00e3-0d00-bf52-cdf80ee71e49",
			"to" : "e3d42069-00e3-0d00-bf56-68850ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "87d42069-00e3-0d00-bf51-8e460ee71e49",
			"to" : "efd42069-00e3-0d00-bf5a-0d640ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "efd42069-00e3-0d00-bf5a-0d640ee71e49",
			"to" : "f3d42069-00e3-0d00-bf5b-256a0ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "e6d42069-00e3-0d00-bf57-12bf0ee71e49",
			"to" : "f3d42069-00e3-0d00-bf5b-256a0ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "f3d42069-00e3-0d00-bf5b-256a0ee71e49",
			"to" : "12d52069-00e3-0d00-bf60-db8a0ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "12d52069-00e3-0d00-bf60-db8a0ee71e49",
			"to" : "ded42069-00e3-0d00-bf54-12270ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "e3d42069-00e3-0d00-bf56-68850ee71e49",
			"to" : "17d52069-00e3-0d00-bf61-6d4b0ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		},
		{
			"from" : "e0d42069-00e3-0d00-bf55-dd270ee71e49",
			"to" : "17d52069-00e3-0d00-bf61-6d4b0ee71e49",
			"color" : {
				"green" : 0.5004887585532747,
				"blue" : 0.5004887585532747,
				"alpha" : 1.0,
				"red" : 0.5004887585532747
			},
			"width" : 1.0,
			"arrow" : false,
			"label" : {
				"x" : 0.5,
				"y" : 0.5,
				"is_visible" : false,
				"text" : "Edge label"
			}
		}
	]
}'}
							asDictionary}
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterWardleyMapSnippetTutor >> renameAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose renames for node';
		priority: 4;
		description: 'Proposes a sensible number of alternative names for nodes (less than ten, but more than one).';
		format: 'Propose renames for node `{1}`';
		examples: {}
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterWardleyMapSnippetTutor >> renameFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Rename';
		priority: 2;
		format: 'Text';
		example: '```
{''Node name'': [''Proposal A'', ''Proposal B'']}
```'
]
