// main.js

function init() {
	addConfirmations();
}

function addConfirmations() {
	// TODO: autofocus
	const forms = document.querySelectorAll("form[data-confirm]");
	forms.forEach((form) => {
		const confirm = document.createElement("dialog");
		const message = document.createElement("p");
		const cancel  = document.createElement("button");
		const accept  = document.createElement("button");
		cancel.type = "button";
		cancel.className = "yes"
		accept.className = "no"
		message.innerText = form.dataset.confirm;
		cancel.innerText = form.dataset.cancel;
		accept.innerText = form.dataset.accept;
		confirm.appendChild(message);
		confirm.appendChild(cancel);
		confirm.appendChild(accept);
		form.appendChild(confirm);
		form.onsubmit = (event) => {
			event.preventDefault();
			confirm.showModal();
		}
		cancel.onclick = (event) => {
			confirm.close();
		}
		accept.onclick = () => {
			form.submit();
		}
	});
}

if (document.readyState == "loading") {
	document.addEventListener("DOMContentLoaded", init);
} else {
	init();
}