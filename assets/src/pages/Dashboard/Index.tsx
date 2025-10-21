import MainLayout from "@/layouts/MainLayout"

function Index() {
  return (
    <>
      <h1 className="mb-8 text-3xl font-bold">Dashboard</h1>
      <p className="mb-8 leading-normal">
        Hey there! Welcome to Ping CRM, a demo app designed to help illustrate how{" "}
        <a
          className="text-indigo-600 underline hover:text-orange-500"
          href="https://inertiajs.com"
        >
          Inertia.js
        </a>{" "}
        works with{" "}
        <a className="text-indigo-600 underline hover:text-orange-500" href="https://react.dev/">
          React
        </a>
        .
      </p>
    </>
  )
}

Index.layout = (page: React.ReactNode) => <MainLayout title="Dashboard" children={page} />

export default Index
