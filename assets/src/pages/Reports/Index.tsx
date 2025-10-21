import MainLayout from "@/layouts/MainLayout"

function Index() {
  return (
    <div>
      <h1 className="mb-8 text-3xl font-bold">Reports</h1>
      <p className="mb-12 leading-normal">Not implemented.</p>
    </div>
  )
}

Index.layout = (page: React.ReactNode) => <MainLayout title="Reports" children={page} />

export default Index
