async function loadMoreProjects(after) {
    const button = document.querySelector("#projects-load-more")
    button.disabled = true;
    button.classList.add("loading");

    const response = await fetch(`/api/repositories?after=${after}`, {
        method: "GET"
    });

    if (!response.ok) {
        console.error("error fetching more repositories:", response);
        return;
    }

    const body = await response.text();
    button.remove();
    document.querySelector("#projects").insertAdjacentHTML("beforeend", body);
}
